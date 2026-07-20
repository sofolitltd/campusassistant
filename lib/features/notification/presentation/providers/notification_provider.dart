import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/di.dart';
import '/core/providers/app_refresh_provider.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

final notificationsProvider = FutureProvider<List<AppNotification>>((
  ref,
) async {
  // Refetch whenever the app-wide refresh trigger fires (e.g. on app resume,
  // see main.dart's didChangeAppLifecycleState) or a push notification
  // arrives (see FirebaseApi._refreshNotifications), not just on first watch.
  ref.watch(appRefreshProvider);
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getNotifications();
});

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).asData?.value ?? [];
  return notifications.where((n) => !n.isRead).length;
});
