import 'package:flutter/material.dart';

import '../../domain/entities/semester.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';

class SemesterGridCard extends StatelessWidget {
  final Semester semester;

  const SemesterGridCard({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget infoRow(String label, String value) {
      return Container(
        padding: const EdgeInsets.only(left: Spacing.sm),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surface.withValues(alpha: 0.5)
              : context.colors.surfaceAlt,
          borderRadius: BorderRadius.circular(RadiusToken.sm),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              '$label:',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(width: Spacing.sm),
            Container(
              constraints: const BoxConstraints(minWidth: 48),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                color: theme.cardColor,
                border: Border.all(color: theme.dividerColor),
              ),
              padding: const EdgeInsets.all(Spacing.xxs),
              child: Text(
                value,
                style: theme.textTheme.titleSmall!.copyWith(fontWeight: .bold),
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
                const SizedBox(height: Spacing.lg),
                Column(
                  mainAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    infoRow('Courses', semester.totalCourses.toString()),
                    infoRow('Credits', semester.totalCredits.toString()),
                    infoRow('Marks', semester.totalMarks.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 16,
          child: Icon(
            Icons.keyboard_arrow_right,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
