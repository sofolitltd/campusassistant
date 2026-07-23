import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/career_job.dart';
import '../providers/career_job_provider.dart';

/// Ported from personalassistant's StatusBadge/status_picker.dart — tapping
/// the pill opens a bottom sheet to change status, instead of an inline
/// SegmentedButton.
class JobStatusBadge extends ConsumerWidget {
  final CareerJob job;

  const JobStatusBadge({super.key, required this.job});

  Color _dotColor(ColorScheme cs) {
    switch (job.status) {
      case CareerJobStatus.applied:
        return Colors.blue;
      case CareerJobStatus.completed:
        return Colors.green;
      case CareerJobStatus.pending:
        return Colors.amber.shade700;
    }
  }

  String _label(CareerJobStatus status) {
    switch (status) {
      case CareerJobStatus.pending:
        return 'Pending';
      case CareerJobStatus.applied:
        return 'Applied';
      case CareerJobStatus.completed:
        return 'Completed';
    }
  }

  IconData _icon(CareerJobStatus status) {
    switch (status) {
      case CareerJobStatus.pending:
        return LucideIcons.hourglass;
      case CareerJobStatus.applied:
        return LucideIcons.checkCircle;
      case CareerJobStatus.completed:
        return LucideIcons.checkCheck;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _showStatusPicker(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: RadiusToken.circular(RadiusToken.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 7, height: 7, decoration: BoxDecoration(color: _dotColor(cs), shape: BoxShape.circle)),
            const SizedBox(width: Spacing.sm),
            Text(_label(job.status), style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(width: Spacing.xxs),
            Icon(LucideIcons.chevronDown, size: 14, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _showStatusPicker(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusToken.xl))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Change Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: Spacing.xl),
              for (final status in CareerJobStatus.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.md)),
                    tileColor: job.status == status ? cs.primaryContainer : cs.surfaceContainerLow,
                    leading: Icon(_icon(status), color: job.status == status ? cs.primary : cs.onSurfaceVariant),
                    title: Text(_label(status), style: TextStyle(fontWeight: job.status == status ? FontWeight.bold : FontWeight.normal)),
                    trailing: job.status == status ? Icon(LucideIcons.check, color: cs.primary) : null,
                    onTap: () {
                      if (job.status != status) {
                        ref.read(careerJobActionsProvider).setStatus(job.id, status);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
