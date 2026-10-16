import 'dart:async';

import '/core/auth/token_store.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;

import 'firebase_options.dart';
import 'routes/router_config.dart';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart'
    show PathUrlStrategy, setUrlStrategy;
import 'package:go_router/go_router.dart';

import '/core/providers/theme_provider.dart';
import '/core/providers/app_refresh_provider.dart';
import '/core/theme/app_scroll_behavior.dart';
import '/core/theme/app_theme.dart';
import '/core/cache/cache_manager.dart';
import '/core/cache/connectivity_service.dart';
import '/core/cache/sync_manager.dart';
import '/core/websocket/websocket_service.dart';
import '/core/widgets/offline_banner.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/services/firebase_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initBackgroundHandler();
  if (!kIsWeb) {
    // Not awaited: adapter init can take seconds on a cold start and nothing
    // before the first frame needs it — ad requests made before it finishes
    // are queued by the SDK.
    unawaited(MobileAds.instance.initialize());
  }

  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
    // sqflite has no native web implementation — this backs it with sql.js
    // (wasm) + IndexedDB via web/sqlite3.wasm and web/sqflite_sw.js (see
    // `dart run sqflite_common_ffi_web:setup`), so ChatDatabase works on web.
    databaseFactory = databaseFactoryFfiWeb;
  }
  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(ProviderScope(child: const MyApp()));
}

// Built once: a fresh ThemeData on every MyApp rebuild makes every
// Theme.of(context) dependent in the app rebuild too.
final ThemeData _lightTheme = buildLightTheme();
final ThemeData _darkTheme = buildDarkTheme();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize connectivity listener and WebSocket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initConnectivity();
      _initWebSocket();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    final connectivity = ref.read(connectivityServiceProvider);

    // Listen for connectivity changes and update the provider
    connectivity.onConnectivityChanged.listen((isConnected) {
      ref.read(isConnectedProvider.notifier).update(isConnected);

      // When connection returns, process pending syncs
      if (isConnected) {
        final syncManager = ref.read(syncManagerProvider);
        syncManager.processPendingSyncs();
      }
    });

    // Perform initial check (emits result to stream, caught by listener above)
    await connectivity.checkConnectivity();
  }

  void _initWebSocket() {
    // Listen for auth state changes to connect/disconnect WebSocket.
    // ref.listen only works inside build(); this runs from a post-frame
    // callback, so it needs listenManual instead (auto-disposed with this
    // State, same as ref.listen would be).
    ref.listenManual(currentUserProvider, (previous, next) {
      final user = next.value;
      if (user != null && !kIsWeb) {
        // User logged in - connect WebSocket
        _connectWebSocket();
      } else if (user == null) {
        // User logged out - disconnect WebSocket
        final wsService = ref.read(websocketServiceProvider);
        wsService.disconnect();
        ref.read(websocketConnectedProvider.notifier).update(false);
      }
    });

    // If user is already logged in, connect now
    final userAsync = ref.read(currentUserProvider);
    if (userAsync.value != null && !kIsWeb) {
      _connectWebSocket();
    }
  }

  Future<void> _connectWebSocket() async {
    try {
      final token = await TokenStore.instance.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final wsService = ref.read(websocketServiceProvider);
        await wsService.connect(token);
        ref
            .read(websocketConnectedProvider.notifier)
            .update(wsService.isConnected);
      }
    } catch (e) {
      debugPrint('[Main] WebSocket connection failed: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // If user just cleared cache, skip automatic refresh
      ref.read(cacheManagerProvider).isRecentlyCleared().then((
        recentlyCleared,
      ) {
        if (!recentlyCleared) {
          ref.read(appRefreshProvider.notifier).trigger();
        }
      });

      // Re-sync FCM topic subscriptions on resume, in case the account's
      // university/department/batch changed server-side while this session
      // stayed logged in without a token refresh. Idempotent and best-effort.
      FirebaseApi().initNotifications();

      // Process pending syncs when app resumes
      if (!kIsWeb) {
        final syncManager = ref.read(syncManagerProvider);
        syncManager.processPendingSyncs();

        // Reconnect WebSocket if needed
        final wsService = ref.read(websocketServiceProvider);
        wsService.reconnectIfNeeded();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeModeAsync = ref.watch(themeProvider);

    // One MaterialApp for every state: system mode while the saved preference
    // loads (or fails to), then the saved one. Swapping between three
    // MaterialApp instances rebuilt the whole tree for no reason.
    return MaterialApp.router(
      title: 'Campus Assistant',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      themeMode: themeModeAsync.value ?? ThemeMode.system,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      routerConfig: router,
      // Temporary: third-party deps still import flutter/material.dart.
      // ignore: deprecated_member_use
      builder: (context, child) => MaterialUiCompatibilityBridge(
        child: OfflineBanner(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
