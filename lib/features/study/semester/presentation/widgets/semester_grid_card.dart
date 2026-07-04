import 'package:flutter/material.dart';

import '../../domain/entities/semester.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';
import 'package:campusassistant/core/theme/tokens/app_spacing.dart';

class SemesterGridCard extends StatelessWidget {
  final Semester semester;

  const SemesterGridCard({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget infoRow(String label, String value) {
      return Container(
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surface.withValues(alpha: 0.5)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label:',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              constraints: const BoxConstraints(minWidth: 48),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: theme.cardColor,
                border: Border.all(color: theme.dividerColor),
              ),
              padding: const EdgeInsets.all(2),
              child: Text(
                value,
                style: theme.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerRight,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  semester.name,
                  style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: Spacing.lg),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
