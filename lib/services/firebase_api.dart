import 'dart:convert';
import 'dart:developer';
import 'dart:io' show File, Platform;
import 'dart:typed_data' show Uint8List;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '/core/network/api_client.dart';
import '/core/network/api_endpoints.dart';
import '/core/providers/app_refresh_provider.dart';
import '/features/auth/data/datasources/auth_local_data_source.dart';
import '/routes/app_route.dart';
import '/routes/router_config.dart' show rootNavigatorKey;
import 'device_repository.dart';

/// Must be a top-level (or static) function — firebase_messaging runs it in
/// a separate isolate when a push arrives while the app is backgrounded/killed.
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('[FCM] Background message: ${message.messageId}');
}

/// Owns push-notification setup: permission + token retrieval, registering
/// the token with the backend, showing a local notification when the app is
/// foregrounded, and deep-linking via the notification's `action_route` when
/// tapped — the same mechanism already used for in-app notification taps.
class FirebaseApi {
  static final FirebaseApi _instance = FirebaseApi._internal();
  factory FirebaseApi() => _instance;
  FirebaseApi._internal();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
  );

  String? _currentToken;
  bool _handlersRegistered = false;

  /// The current app install's FCM token, if it's been fetched yet — used to
  /// flag "this device" in the device-management screen and to exclude it
  /// from a "log out other devices" action.
  String? get currentToken => _currentToken;

  DeviceRepository get _deviceRepository {
    const storage = FlutterSecureStorage();
    final apiClient = ApiClient(
      baseUrl: ApiEndpoints.baseUrl,
      getToken: () => storage.read(key: AuthLocalDataSourceImpl.cachedTokenKey),
    );
    return DeviceRepository(apiClient: apiClient);
  }

  String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    return 'android';
  }

  /// Call once, very early in main() before runApp — registers the top-level
  /// background handler, which firebase_messaging requires be set before
  /// Firebase.initializeApp's isolate starts handling background messages.
  Future<void> initBackgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  /// Call after a successful login (and on app start if already logged in):
  /// requests permission, fetches the current token, registers it with the
  /// backend, and wires up foreground/tap message handlers (once).
  Future<void> initNotifications() async {
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Web needs a VAPID key (Firebase Console → Project Settings →
      // Cloud Messaging → Web configuration → Web Push certificates) —
      // getToken silently returns null on web without one, which is why a
      // web session would otherwise never show up in the device list.
      String? vapidKey;
      if (kIsWeb) {
        vapidKey = dotenv.env['FCM_VAPID_KEY'];
        if (vapidKey == null || vapidKey.isEmpty) {
          log(
            '[FCM] FCM_VAPID_KEY not set in .env — web push token cannot be fetched',
          );
        }
      }

      final token = await _messaging.getToken(vapidKey: vapidKey);
      if (token != null) {
        _currentToken = token;
        await _registerToken(token);
      }

      _messaging.onTokenRefresh.listen((newToken) {
        _currentToken = newToken;
        _registerToken(newToken);
      });

      if (!_handlersRegistered) {
        _handlersRegistered = true;
        await _initLocalNotifications();
        _messaging.getInitialMessage().then(_handleTap);
        FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      }
    } catch (e) {
      log('[FCM] initNotifications failed: $e');
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      await _deviceRepository.registerDevice(token, _platform);
    } catch (e) {
      log('[FCM] failed to register device token: $e');
    }
  }

  /// Call before logging out so this device stops receiving push addressed
  /// to the account that's signing out. Best-effort — never blocks logout.
  Future<void> unregisterCurrentDevice() async {
    final token = _currentToken;
    if (token == null) return;
    try {
      await _deviceRepository.unregisterDevice(token);
    } catch (e) {
      log('[FCM] failed to unregister device token: $e');
    }
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null) return;
        _handleTap(
          RemoteMessage.fromMap(jsonDecode(payload) as Map<String, dynamic>),
        );
      },
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final imageUrl = notification.android?.imageUrl ?? notification.apple?.imageUrl;
    final imageBytes = await _downloadImage(imageUrl);

    BigPictureStyleInformation? bigPictureStyle;
    List<DarwinNotificationAttachment>? iosAttachments;
    if (imageBytes != null) {
      bigPictureStyle = BigPictureStyleInformation(
        ByteArrayAndroidBitmap(imageBytes),
        largeIcon: ByteArrayAndroidBitmap(imageBytes),
        contentTitle: notification.title,
        summaryText: notification.body,
      );
      final iosAttachmentPath = await _writeToTempFile(imageBytes, notification.hashCode);
      if (iosAttachmentPath != null) {
        iosAttachments = [DarwinNotificationAttachment(iosAttachmentPath)];
      }
    }

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: '@mipmap/ic_launcher',
          styleInformation: bigPictureStyle,
        ),
        iOS: DarwinNotificationDetails(attachments: iosAttachments),
      ),
      payload: jsonEncode(message.toMap()),
    );
    _refreshNotifications();
  }

  /// Best-effort image fetch for a foreground notification's big-picture
  /// style — the app builds/shows this notification itself (unlike the
  /// background/killed-app case, which FCM's native SDK auto-displays with
  /// the image already, no extra code needed), so the bytes have to be
  /// fetched here.
  Future<Uint8List?> _downloadImage(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (e) {
      log('[FCM] failed to fetch notification image: $e');
    }
    return null;
  }

  /// iOS notification attachments require a file path, not raw bytes.
  Future<String?> _writeToTempFile(Uint8List bytes, int id) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/fcm_notification_$id.jpg');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      log('[FCM] failed to write notification image to disk: $e');
      return null;
    }
  }

  void _handleTap(RemoteMessage? message) {
    _refreshNotifications();
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;
    final actionRoute = message?.data['action_route'] as String?;
    if (actionRoute != null && actionRoute.isNotEmpty) {
      GoRouter.of(context).push(actionRoute);
    } else if (message != null) {
      // No deep link on this notification — still take the user somewhere
      // relevant instead of leaving the tap looking like it did nothing.
      GoRouter.of(context).push(AppRoute.notifications.path);
    }
  }

  /// Bumps the app-wide refresh signal so notificationsProvider (and the
  /// unread badge derived from it) refetches immediately instead of only on
  /// the next app resume — a push landing while the app is open/foregrounded
  /// wouldn't otherwise be reflected in the UI until something else triggers
  /// a rebuild.
  void _refreshNotifications() {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;
    ProviderScope.containerOf(
      context,
      listen: false,
    ).read(appRefreshProvider.notifier).trigger();
  }
}
