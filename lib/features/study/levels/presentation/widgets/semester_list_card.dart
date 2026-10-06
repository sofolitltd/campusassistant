import 'package:flutter/material.dart';

import '../../domain/entities/semester.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';

class SemesterListCard extends StatelessWidget {
  final Semester semester;

  const SemesterListCard({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget infoChip(String label, String value, {bool useShade200 = false}) {
      return Container(
        padding: const EdgeInsets.only(left: Spacing.md),
        decoration: BoxDecoration(
          color: useShade200
              ? (isDark
                    ? theme.colorScheme.surface.withValues(alpha: 0.5)
                    : context.colors.border)
              : (isDark
                    ? theme.colorScheme.surface.withValues(alpha: 0.5)
                    : context.colors.surfaceAlt),
          borderRadius: BorderRadius.circular(RadiusToken.sm),
        ),
        child: Row(
          children: [
            Text(
              '$label:',
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Container(
              constraints: const BoxConstraints(minWidth: 32),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                color: theme.cardColor,
                border: Border.all(color: theme.dividerColor),
              ),
              padding: const EdgeInsets.all(Spacing.xxs),
              child: Text(
                value,
                style: theme.textTheme.bodyMedium!.copyWith(fontWeight: .bold),
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      clipBehavior: .none,
      alignment: Alignment.centerRight,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(color: context.colors.border),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            height: 88,
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  semester.name,
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: .bold,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: .horizontal,
                  child: Row(
                    mainAxisAlignment: .start,
                    spacing: 12,
                    children: [
                      infoChip('Courses', semester.totalCourses.toString()),
                      infoChip('Credits', semester.totalCredits.toString()),
                      infoChip(
                        'Marks',
                        semester.totalMarks.toString(),
                        useShade200: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 12,
          child: Icon(
            Icons.keyboard_arrow_right,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
