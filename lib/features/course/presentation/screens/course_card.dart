import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/features/course/domain/entities/course.dart';
import '/widgets/headline.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.courseCategory,
    required this.courses,
    required this.selectedBatch,
    required this.selectedSemester,
  });

  final String courseCategory;
  final List<Course> courses;
  final String selectedBatch;
  final String selectedSemester;

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Spacing.sm, bottom: 0),
          child: Headline(title: courseCategory),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.sm,
            horizontal: Spacing.sm,
          ),
          itemCount: courses.length,
          separatorBuilder: (_, _) => const SizedBox(height: Spacing.lg),
          itemBuilder: (context, index) {
            final course = courses[index];
            return InkWell(
              onTap: () {
                context.pushNamed(
                  'courseDetails',
                  pathParameters: {'courseCode': course.courseCode},
                  queryParameters: {
                    'batch': selectedBatch,
                    'semester': selectedSemester,
                  },
                );
              },
              child: CourseCardContent(courseModel: course),
            );
          },
        ),
        const SizedBox(height: Spacing.xl),
      ],
    );
  }
}

/// Public per-item course card body (thumbnail + title + code/credits/marks
/// strip), no tap behavior baked in — wrap with your own `InkWell`/
/// `GestureDetector` where you use it (see [CourseCard] above for the
/// canonical wiring to the course details route).
class CourseCardContent extends StatelessWidget {
  const CourseCardContent({super.key, required this.courseModel});

  final Course courseModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md + 2),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surface.withValues(alpha: 0.5)
                  : context.colors.primary,
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            // Border drawn over the image with the same radius, so the image
            // and its border share one curve.
            foregroundDecoration: BoxDecoration(
              border: Border.all(color: context.colors.border),
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            clipBehavior: Clip.antiAlias,
            width: 80,
            height: 90,
            child: CachedNetworkImage(
              imageUrl: ApiEndpoints.resolveImageUrl(courseModel.thumbnailURL),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surface.withValues(alpha: 0.5)
                      : context.colors.primary,
                  borderRadius: BorderRadius.circular(RadiusToken.md),
                  image: DecorationImage(image: imageProvider, fit: .cover),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  const CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surface.withValues(alpha: 0.5)
                      : context.colors.primary,
                  borderRadius: BorderRadius.circular(RadiusToken.md),
                  image: const DecorationImage(
                    fit: .cover,
                    image: AssetImage('assets/images/placeholder.png'),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: SizedBox(
              height: 90,
              child: Column(
                mainAxisSize: .max,
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        courseModel.courseTitle,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: .bold,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.sm,
                      Spacing.xs,
                      Spacing.sm,
                      Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.surface.withValues(alpha: 0.5)
                          : context.colors.surfaceAlt.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(RadiusToken.sm),
                    ),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        courseInfo(
                          context,
                          title: 'Course Code',
                          value: courseModel.courseCode.toUpperCase(),
                          alignRight: true,
                        ),
                        courseInfo(
                          context,
                          title: 'Credits',
                          value: courseModel.totalCredits.toString(),
                          alignRight: true,
                        ),
                        courseInfo(
                          context,
                          title: 'Marks',
                          value: courseModel.totalMarks.toString(),
                          alignRight: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Column courseInfo(
  BuildContext context, {
  required String title,
  required String value,
  bool alignRight = false,
}) {
  final theme = Theme.of(context);

  return Column(
    crossAxisAlignment: alignRight
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: theme.textTheme.labelSmall!.copyWith(
          color: context.colors.textSubtle,
        ),
      ),
      Text(
        value,
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: .bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    ],
  );
}
