import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../../circular/data/models/circular_category.dart';
import '../../../circular/presentation/providers/circular_provider.dart';
import '../../data/models/career_job.dart';
import '../providers/career_job_provider.dart';
import 'job_detail_helpers.dart';

/// Same tap-to-popup-menu pattern as JobStatusBadge, for changing a job's
/// category from the detail page instead of only through Edit.
class JobCategoryBadge extends ConsumerWidget {
  final CareerJob job;
  final GlobalKey _badgeKey = GlobalKey();

  JobCategoryBadge({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(circularCategoriesProvider);

    return GestureDetector(
      key: _badgeKey,
      onTap: () => _showCategoryPicker(context, ref, categoriesAsync),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        decoration: BoxDecoration(
          color: cs.tertiaryContainer,
          borderRadius: RadiusToken.circular(RadiusToken.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.tag, size: 12, color: cs.onTertiaryContainer),
            const SizedBox(width: Spacing.sm),
            Text(
              job.category?.name ?? 'Uncategorized',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onTertiaryContainer,
              ),
            ),
            const SizedBox(width: Spacing.xxs),
            Icon(LucideIcons.chevronDown, size: 14, color: cs.onTertiaryContainer),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<CircularCategory>> categoriesAsync,
  ) {
    final categories = categoriesAsync.maybeWhen(data: (v) => v, orElse: () => const <CircularCategory>[]);
    final cs = Theme.of(context).colorScheme;
    final renderBox = _badgeKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu<String?>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 4,
        position.dx + size.width,
        position.dy + size.height + 4,
      ),
      shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.sm)),
      color: cs.surfaceContainerHighest,
      items: [
        _categoryMenuItem(context, id: null, label: 'Uncategorized', isSelected: job.categoryId == null),
        for (final category in categories)
          _categoryMenuItem(context, id: category.id, label: category.name, isSelected: job.categoryId == category.id),
      ],
    ).then((value) async {
      if (value == job.categoryId) return;
      if (!context.mounted) return;

      final selectedLabel = value == null
          ? 'Uncategorized'
          : categories.firstWhere((c) => c.id == value).name;
      final confirmed = await confirmJobFieldChange(
        context,
        title: 'Change category?',
        message: 'Set this job\'s category to "$selectedLabel"?',
      );
      if (!confirmed) return;

      final draft = CareerJob(
        id: job.id,
        title: job.title,
        organization: job.organization,
        categoryId: value,
        postLink: job.postLink,
        resourceLink: job.resourceLink,
        attachmentUrls: job.attachmentUrls,
        publishDate: job.publishDate,
        deadlineDate: job.deadlineDate,
        status: job.status,
        notes: job.notes,
        createdAt: job.createdAt,
        scope: job.scope,
      );
      ref.read(careerJobActionsProvider).updateJob(job.id, draft);
    });
  }

  PopupMenuItem<String?> _categoryMenuItem(
    BuildContext context, {
    required String? id,
    required String label,
    required bool isSelected,
  }) {
    final cs = Theme.of(context).colorScheme;
    return PopupMenuItem<String?>(
      value: id,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
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
  }
}
