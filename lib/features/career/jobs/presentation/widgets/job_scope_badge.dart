import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/career_job.dart';
import '../providers/career_job_provider.dart';
import 'job_detail_helpers.dart';

/// Same tap-to-popup-menu pattern as JobStatusBadge/JobCategoryBadge, for
/// changing who a job is shared with from the detail page instead of only
/// through Edit.
class JobScopeBadge extends ConsumerWidget {
  final CareerJob job;
  final GlobalKey _badgeKey = GlobalKey();

  JobScopeBadge({super.key, required this.job});

  String _label(CareerJobScope scope) {
    switch (scope) {
      case CareerJobScope.private_:
        return 'Just me';
      case CareerJobScope.batch:
        return 'My Batch';
      case CareerJobScope.department:
        return 'My Department';
      case CareerJobScope.university:
        return 'My University';
    }
  }

  IconData _icon(CareerJobScope scope) {
    return scope == CareerJobScope.private_ ? LucideIcons.lock : LucideIcons.radio;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      key: _badgeKey,
      onTap: () => _showScopePicker(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: RadiusToken.circular(RadiusToken.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon(job.scope), size: 12, color: cs.primary),
            const SizedBox(width: Spacing.sm),
            Text(
              _label(job.scope),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: Spacing.xxs),
            Icon(LucideIcons.chevronDown, size: 14, color: cs.primary),
          ],
        ),
      ),
    );
  }

  void _showScopePicker(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final renderBox = _badgeKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu<CareerJobScope>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 4,
        position.dx + size.width,
        position.dy + size.height + 4,
      ),
      shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.sm)),
      color: cs.surfaceContainerHighest,
      items: CareerJobScope.values.map((scope) {
        final isSelected = job.scope == scope;
        return PopupMenuItem<CareerJobScope>(
          value: scope,
          child: Row(
            children: [
              Icon(
                _icon(scope),
                size: 18,
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  _label(scope),
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
    ).then((newScope) async {
      if (newScope == null || newScope == job.scope) return;
      if (!context.mounted) return;

      final confirmed = await confirmJobFieldChange(
        context,
        title: 'Change sharing?',
        message: 'Share this job with "${_label(newScope)}"?',
      );
      if (!confirmed) return;

      final draft = CareerJob(
        id: job.id,
        title: job.title,
        organization: job.organization,
        categoryId: job.categoryId,
        postLink: job.postLink,
        resourceLink: job.resourceLink,
        attachmentUrls: job.attachmentUrls,
        publishDate: job.publishDate,
        deadlineDate: job.deadlineDate,
        status: job.status,
        notes: job.notes,
        createdAt: job.createdAt,
        scope: newScope,
      );
      ref.read(careerJobActionsProvider).updateJob(job.id, draft);
    });
  }
}
