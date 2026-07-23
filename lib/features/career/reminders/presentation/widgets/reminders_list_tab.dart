import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/models/career_reminder.dart';
import '../providers/career_reminder_provider.dart';

class RemindersListTab extends ConsumerWidget {
  const RemindersListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(myCareerRemindersProvider);

    return remindersAsync.when(
      data: (reminders) {
        final upcoming = reminders.where((r) => r.status == CareerReminderStatus.pending).toList();
        final past = reminders.where((r) => r.status != CareerReminderStatus.pending).toList();

        if (reminders.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.bell, size: 48, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 12),
                const Text('No reminders yet'),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          children: [
            if (upcoming.isNotEmpty) ...[
              const _SectionHeader('Upcoming'),
              for (final reminder in upcoming) _ReminderTile(reminder: reminder, ref: ref),
            ],
            if (past.isNotEmpty) ...[
              const _SectionHeader('Past'),
              for (final reminder in past) _ReminderTile(reminder: reminder, ref: ref),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Failed to load reminders: $err')),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final CareerReminder reminder;
  final WidgetRef ref;
  const _ReminderTile({required this.reminder, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(reminder.id),
      direction: reminder.status == CareerReminderStatus.pending
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.cancel_outlined),
      ),
      onDismissed: (_) => ref.read(careerReminderActionsProvider).cancelReminder(reminder.id),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: Icon(
            reminder.status == CareerReminderStatus.sent ? Icons.notifications_active : Icons.notifications_outlined,
          ),
          title: Text(reminder.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(_formatDateTime(reminder.remindAt)),
          trailing: reminder.status != CareerReminderStatus.pending
              ? Chip(label: Text(reminder.status.name.toUpperCase()))
              : null,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day}/${dt.month}/${dt.year} $hour:$minute $period';
  }
}
