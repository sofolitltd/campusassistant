import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/models/career_reminder.dart';
import '../providers/career_reminder_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class RemindersListTab extends ConsumerWidget {
  const RemindersListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(myCareerRemindersProvider);

    return remindersAsync.when(
      data: (reminders) {
        final upcoming = reminders
            .where((r) => r.status == CareerReminderStatus.pending)
            .toList();
        final past = reminders
            .where((r) => r.status != CareerReminderStatus.pending)
            .toList();

        if (reminders.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                Icon(
                  LucideIcons.bell,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: Spacing.md),
                const Text('No reminders yet'),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            if (upcoming.isNotEmpty) ...[
              const _SectionHeader('Upcoming'),
              for (final reminder in upcoming)
                _ReminderTile(reminder: reminder, ref: ref),
            ],
            if (past.isNotEmpty) ...[
              const _SectionHeader('Past'),
              for (final reminder in past)
                _ReminderTile(reminder: reminder, ref: ref),
            ],
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
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
      // 8 above + the previous card's 8 bottom margin = the 16 that sits above
      // the first card in the jobs tab.
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.sm,
        Spacing.lg,
        Spacing.xs,
      ),
      // Same style as every other section title in the app (HomeSectionHeader).
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: context.colors.text,
        ),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final CareerReminder reminder;
  final WidgetRef ref;
  const _ReminderTile({required this.reminder, required this.ref});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pending = reminder.status == CareerReminderStatus.pending;
    return Dismissible(
      key: ValueKey(reminder.id),
      direction: pending ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.xl),
        child: const Icon(Icons.cancel_outlined),
      ),
      onDismissed: (_) =>
          ref.read(careerReminderActionsProvider).cancelReminder(reminder.id),
      // Same card chrome as the job card (My Jobs tab).
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.sm,
        ),
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: pending ? colors.primarySubtle : colors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: Icon(
                reminder.status == CareerReminderStatus.sent
                    ? LucideIcons.bellRing
                    : LucideIcons.bell,
                size: 18,
                color: pending ? colors.primary : colors.textMuted,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        size: 12,
                        color: colors.textMuted,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Flexible(
                        child: Text(
                          _formatDateTime(reminder.remindAt),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!pending) ...[
              const SizedBox(width: Spacing.sm),
              _StatusButton(status: reminder.status),
            ],
          ],
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

/// Compact tonal status button (28px tall) for sent / cancelled reminders.
class _StatusButton extends StatelessWidget {
  final CareerReminderStatus status;
  const _StatusButton({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sent = status == CareerReminderStatus.sent;
    final fg = sent ? colors.success : colors.danger;
    final bg = sent ? colors.successSubtle : colors.dangerSubtle;

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(RadiusToken.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(sent ? LucideIcons.check : LucideIcons.x, size: 12, color: fg),
          const SizedBox(width: Spacing.xs),
          Text(
            status.name[0].toUpperCase() + status.name.substring(1),
            style: TextStyle(
              color: fg,
              fontSize: FontSizeToken.xs,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
