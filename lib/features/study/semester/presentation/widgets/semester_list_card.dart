import 'package:flutter/material.dart';

import '../../domain/entities/semester.dart';

class SemesterListCard extends StatelessWidget {
  final Semester semester;

  const SemesterListCard({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget infoChip(String label, String value, {bool useShade200 = false}) {
      return Container(
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: useShade200
              ? (isDark
                  ? theme.colorScheme.surface.withValues(alpha: 0.5)
                  : Colors.grey.shade200)
              : (isDark
                  ? theme.colorScheme.surface.withValues(alpha: 0.5)
                  : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(
              '$label:',
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              constraints: const BoxConstraints(minWidth: 32),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: theme.cardColor,
                border: Border.all(color: theme.dividerColor),
              ),
              padding: const EdgeInsets.all(2),
              child: Text(
                value,
                style: theme.textTheme.bodyMedium!
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
            borderRadius: BorderRadius.circular(12),
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
            width: double.infinity,
            height: 88,
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 12,
                    children: [
                      infoChip('Courses', semester.totalCourses.toString()),
                      infoChip('Credits', semester.totalCredits.toString()),
                      infoChip('Marks', semester.totalMarks.toString(),
                          useShade200: true),
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
