import '/core/network/api_client.dart';
import '/core/network/api_endpoints.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiClient apiClient;

  NotificationRepositoryImpl({required this.apiClient});

  @override
  Future<NotificationPage> getNotifications({int offset = 0, int limit = 20}) async {
    final response = await apiClient.get(
      ApiEndpoints.notifications,
      queryParameters: {'offset': offset, 'limit': limit},
    );
    final body = response.data as Map<String, dynamic>;
    final items = (body['data'] as List? ?? [])
        .map((json) => AppNotification.fromJson(json as Map<String, dynamic>))
        .toList();
    return NotificationPage(
      items: items,
      totalCount: body['count'] as int? ?? items.length,
    );
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
