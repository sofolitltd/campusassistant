import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/career_job.dart';
import '../providers/career_job_provider.dart';
import 'job_detail_helpers.dart';

/// Ported from personalassistant's StatusBadge/status_picker.dart — tapping
/// the pill opens a bottom sheet to change status, instead of an inline
/// SegmentedButton.
class JobStatusBadge extends ConsumerWidget {
  final CareerJob job;
  final GlobalKey _badgeKey = GlobalKey();

  JobStatusBadge({super.key, required this.job});

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
      key: _badgeKey,
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
    final renderBox = _badgeKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 4,
        position.dx + size.width,
        position.dy + size.height + 4,
      ),
      shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.sm)),
      color: cs.surfaceContainerHighest,
      items: CareerJobStatus.values.map((status) {
        final isSelected = job.status == status;
        return PopupMenuItem<String>(
          value: status.name,
          child: Row(
            children: [
              Icon(
                _icon(status),
                size: 18,
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  _label(status),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? cs.primary : cs.onSurface,
                  ),
                ),
              ),
              if (isSelected) Icon(LucideIcons.check, size: 16, color: cs.primary),
            ],
          ),
        );
      }).toList(),
    ).then((value) async {
      if (value == null) return;
      final newStatus = careerJobStatusFromString(value);
      if (job.status == newStatus) return;
      if (!context.mounted) return;

      final confirmed = await confirmJobFieldChange(
        context,
        title: 'Change status?',
        message: 'Mark this job as "${_label(newStatus)}"?',
      );
      if (confirmed) {
        ref.read(careerJobActionsProvider).setStatus(job.id, newStatus);
      }
    });
  }
}
