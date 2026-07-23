import '/core/network/api_client.dart';
import '../models/career_reminder.dart';

class CareerReminderRepository {
  final ApiClient apiClient;

  CareerReminderRepository(this.apiClient);

  Future<List<CareerReminder>> getMyReminders() async {
    final response = await apiClient.get('/my/career-reminders');
    final data = response.data as Map<String, dynamic>;
    final items = data['data'] as List? ?? [];
    return items.map((e) => CareerReminder.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CareerReminder> createReminder({
    String? jobId,
    required String title,
    required DateTime remindAt,
  }) async {
    final response = await apiClient.post(
      '/my/career-reminders',
      data: {
        'job_id': jobId,
        'title': title,
        // Go's time.Time JSON unmarshal requires an RFC3339 offset/Z suffix,
        // which a bare local DateTime.toIso8601String() lacks — send UTC.
        'remind_at': remindAt.toUtc().toIso8601String(),
      },
    );
    return CareerReminder.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> cancelReminder(String id) async {
    await apiClient.delete('/my/career-reminders/$id');
  }
}
