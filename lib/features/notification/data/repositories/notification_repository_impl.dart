import '/core/network/api_client.dart';
import '/core/network/api_endpoints.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiClient apiClient;

  NotificationRepositoryImpl({required this.apiClient});

  @override
  Future<List<AppNotification>> getNotifications() async {
    final response = await apiClient.get(ApiEndpoints.notifications);
    final List<dynamic> data = response.data ?? [];
    return data.map((json) => AppNotification.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await apiClient.post(ApiEndpoints.notificationRead(id));
  }

  @override
  Future<void> markAllAsRead() async {
    await apiClient.post(ApiEndpoints.notificationsReadAll);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await apiClient.delete(ApiEndpoints.notificationDetail(id));
  }
}
