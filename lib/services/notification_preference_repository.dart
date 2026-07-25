import '/core/network/api_client.dart';
import '/core/network/api_endpoints.dart';

/// Manages the caller's per-category notification mute preferences
/// (university/department/batch/club/association/lost_found/career/
/// marketplace/study_material). Absence of a category in the response means
/// subscribed — the backend defaults everything to on.
class NotificationPreferenceRepository {
  final ApiClient apiClient;

  NotificationPreferenceRepository({required this.apiClient});

  Future<Map<String, bool>> getPreferences() async {
    final response = await apiClient.get(ApiEndpoints.notificationPreferences);
    final data = response.data as Map<String, dynamic>;
    return data.map((key, value) => MapEntry(key, value as bool));
  }

  Future<void> updatePreference(String category, bool enabled) async {
    await apiClient.put(
      ApiEndpoints.notificationPreferenceDetail(category),
      data: {'enabled': enabled},
    );
  }
}
