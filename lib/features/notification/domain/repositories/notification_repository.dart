import '../entities/app_notification.dart';

/// One page of a user's notification inbox, plus the total count so the
/// caller knows whether there's more to load.
class NotificationPage {
  final List<AppNotification> items;
  final int totalCount;

  const NotificationPage({required this.items, required this.totalCount});
}

abstract class NotificationRepository {
  Future<NotificationPage> getNotifications({int offset = 0, int limit = 20});

  Future<void> markAsRead(String id);

  Future<void> markAllAsRead();

  Future<void> deleteNotification(String id);
}
