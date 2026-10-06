import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/semester.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

/// Semester card for the two-column grid.
///
/// Colours and the stat containers' corner radius follow [SemesterListCard].
/// An icon tile and a chevron sit on top, then the semester name and below it the three totals (courses, credits, marks) stacked one under
/// another as "Label: value" rows.
class SemesterGridCard extends StatelessWidget {
  final Semester semester;

  const SemesterGridCard({super.key, required this.semester});

  static String _num(num v) => v % 1 == 0 ? '${v.toInt()}' : '$v';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final courses = semester.totalCourses;

    // The card is only half the screen wide, so cap how far large system text
    // can grow inside it.
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: scaler),
      child: Container(
        decoration: BoxDecoration(
          // Same flat fill as the list card.
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(RadiusToken.lg),
                    border: Border.all(color: colors.border),
                  ),
                  child: Icon(
                    LucideIcons.bookOpen,
                    size: 18,
                    color: colors.primary,
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: colors.textSubtle,
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Text(
              semester.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: Spacing.md),
            _StatRow(label: 'Courses', value: '$courses'),
            const SizedBox(height: Spacing.xs),
            _StatRow(label: 'Credits', value: _num(semester.totalCredits)),
            const SizedBox(height: Spacing.xs),
            _StatRow(
              label: 'Marks',
              value: _num(semester.totalMarks),
              darker: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// One "Label:  value" line; the stats stack one under another. Styled like
/// the list card's info chip: a tinted strip with the value in a small
/// bordered box, both with the list's corner radius.
class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.darker = false,
  });

  final String label;
  final String value;

  /// The list card shades its Marks chip one step darker than the others.
  final bool darker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = context.colors;

    final fill = isDark
        ? theme.colorScheme.surface.withValues(alpha: 0.5)
        : (darker ? colors.border : colors.surfaceAlt);

    return Container(
      padding: const EdgeInsets.only(left: Spacing.md),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '$label:',
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(minWidth: 32),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(Spacing.xxs),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                border: Border.all(color: theme.dividerColor),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
