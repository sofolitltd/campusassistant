import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/course/domain/entities/course.dart';
import '/core/theme/app_colors.dart';

class CourseFilterButton extends StatelessWidget {
  final List<Course> courses;
  final String selectedCourseCode;
  final bool redBg;

  const CourseFilterButton({
    super.key,
    required this.courses,
    required this.selectedCourseCode,
    this.redBg = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedCourse = courses.firstWhere(
      (c) => c.courseCode == selectedCourseCode,
      orElse: () => courses.first,
    );

    return GestureDetector(
      onTap: () => _showCourseSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: redBg ? Colors.white.withValues(alpha: 0.15) : null,
          border: Border.all(
            color: redBg
                ? Colors.white.withValues(alpha: 0.4)
                : isDark
                ? Colors.white24
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.bookOpen,
              size: 14,
              color: redBg ? Colors.white : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              selectedCourse.courseCode.toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: redBg ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: redBg ? Colors.white : theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  void _showCourseSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.appColors.primaryColor;
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = searchText.isEmpty
                ? courses
                : courses
                      .where(
                        (c) =>
                            c.courseCode.toLowerCase().contains(
                              searchText.toLowerCase(),
                            ) ||
                            c.courseTitle.toLowerCase().contains(
                              searchText.toLowerCase(),
                            ),
                      )
                      .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Course',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            LucideIcons.x,
                            size: 20,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withAlpha(12)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => searchText = v),
                        decoration: InputDecoration(
                          hintText: 'Search course...',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            LucideIcons.search,
                            size: 18,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final course = filtered[index];
                        final isSelected =
                            course.courseCode == selectedCourseCode;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            if (!isSelected) {
                              context.go(
                                Uri(
                                  path: '/study/courses/${course.courseCode}',
                                  queryParameters: {
                                    if (course.semesterName != null)
                                      'semester': course.semesterName!,
                                  },
                                ).toString(),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primary.withValues(
                                      alpha: isDark ? 0.22 : 0.12,
                                    )
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.courseCode.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected
                                              ? primary
                                              : (isDark
                                                    ? Colors.white54
                                                    : Colors.grey.shade600),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        course.courseTitle,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isSelected
                                              ? primary
                                              : (isDark
                                                    ? Colors.white
                                                    : Colors.black87),
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    LucideIcons.check,
                                    color: Theme.of(
                                      context,
                                    ).appColors.primaryColor,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
