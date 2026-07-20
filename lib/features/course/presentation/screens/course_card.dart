import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/features/course/domain/entities/course.dart';
import '/widgets/headline.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/network/api_endpoints.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 0),
          child: Headline(title: courseCategory),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
              child: _CourseCardContent(courseModel: course),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _CourseCardContent extends StatelessWidget {
  const _CourseCardContent({required this.courseModel});

  final Course courseModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
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
      child: Row(
        spacing: 12,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surface.withValues(alpha: 0.5)
                  : Colors.teal.shade50,
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            width: 80,
            height: 90,
            child: CachedNetworkImage(
              imageUrl: ApiEndpoints.resolveImageUrl(courseModel.thumbnailURL),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surface.withValues(alpha: 0.5)
                      : Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  const CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surface.withValues(alpha: 0.5)
                      : Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(6),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
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
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseModel.courseTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 3, 8, 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.surface.withValues(alpha: 0.5)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  final isDark = theme.brightness == Brightness.dark;

  return Column(
    crossAxisAlignment: alignRight
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: theme.textTheme.labelSmall!.copyWith(
          color: isDark ? Colors.white70 : Colors.grey,
        ),
      ),
      Text(
        value,
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    ],
  );
}
