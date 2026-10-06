import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/course/domain/entities/course.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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

    final selectedCourse = courses.firstWhere(
      (c) => c.courseCode == selectedCourseCode,
      orElse: () => courses.first,
    );

    return GestureDetector(
      onTap: () => _showCourseSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: redBg ? context.colors.surface.withValues(alpha: 0.15) : null,
          border: Border.all(
            color: redBg
                ? context.colors.onPrimary.withValues(alpha: 0.4)
                : context.colors.borderStrong,
          ),
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.bookOpen,
              size: 14,
              color: redBg
                  ? context.colors.onPrimary
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: Spacing.sm),
            Text(
              selectedCourse.courseCode.toUpperCase(),
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: .bold,
                color: redBg
                    ? context.colors.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: redBg
                  ? context.colors.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  void _showCourseSheet(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.appColors.primary;
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
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
              padding: const EdgeInsets.only(top: Spacing.md),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.colors.borderStrong,
                        borderRadius: BorderRadius.circular(RadiusToken.xs),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          'Select Course',
                          style: TextStyle(
                            fontSize: FontSizeToken.xl,
                            fontWeight: .bold,
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
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(RadiusToken.lg),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => searchText = v),
                        decoration: InputDecoration(
                          hintText: 'Search course...',
                          hintStyle: TextStyle(
                            color: context.colors.textSubtle,
                            fontSize: FontSizeToken.base,
                          ),
                          prefixIcon: Icon(
                            LucideIcons.search,
                            size: 18,
                            color: context.colors.textSubtle,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: Spacing.md,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                      ),
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
                              vertical: Spacing.xxs,
                              horizontal: Spacing.sm,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.lg,
                              vertical: Spacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.colors.primarySubtle
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                RadiusToken.md,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.courseCode.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: FontSizeToken.sm,
                                          color: isSelected
                                              ? primary
                                              : (context.colors.textMuted),
                                          fontWeight: .w500,
                                        ),
                                      ),
                                      const SizedBox(height: Spacing.xxs),
                                      Text(
                                        course.courseTitle,
                                        style: TextStyle(
                                          fontSize: FontSizeToken.lg,
                                          color: isSelected
                                              ? primary
                                              : (context.colors.text),
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                        maxLines: 2,
                                        overflow: .ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    LucideIcons.check,
                                    color: Theme.of(context).appColors.primary,
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
