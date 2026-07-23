import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../../presentation/providers/career_refresh_provider.dart';
import '../../data/models/career_reminder.dart';

final myCareerRemindersProvider =
    FutureProvider<List<CareerReminder>>((ref) async {
  ref.watch(careerRefreshProvider);
  final repo = ref.watch(careerReminderRepositoryProvider);
  final reminders = await repo.getMyReminders();
  reminders.sort((a, b) => a.remindAt.compareTo(b.remindAt));
  return reminders;
});

class CareerReminderActions {
  final Ref ref;
  CareerReminderActions(this.ref);

  Future<void> createReminder({
    String? jobId,
    required String title,
    required DateTime remindAt,
  }) async {
    await ref.read(careerReminderRepositoryProvider).createReminder(
          jobId: jobId,
          title: title,
          remindAt: remindAt,
        );
    ref.read(careerRefreshProvider.notifier).bump();
  }

  Future<void> cancelReminder(String id) async {
    await ref.read(careerReminderRepositoryProvider).cancelReminder(id);
    ref.read(careerRefreshProvider.notifier).bump();
  }
}

final careerReminderActionsProvider = Provider<CareerReminderActions>((ref) {
  return CareerReminderActions(ref);
});
