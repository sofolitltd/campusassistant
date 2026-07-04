import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/features/course/domain/entities/course.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/chapter/presentation/providers/chapter_provider.dart';
import '../semester/presentation/providers/semester_provider.dart';
import '/routes/app_route.dart';

class CourseChaptersScreen extends ConsumerStatefulWidget {
  const CourseChaptersScreen({
    super.key,
    required this.courseType,
    required this.courseModel,
    this.universityId,
    this.departmentId,
    this.batch,
    this.semester,
  });

  final String courseType;
  final Course courseModel;
  final String? universityId;
  final String? departmentId;
  final String? batch;
  final String? semester;

  @override
  ConsumerState<CourseChaptersScreen> createState() =>
      _CourseChaptersScreenState();
}

class _CourseChaptersScreenState extends ConsumerState<CourseChaptersScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use the reactive resolved batch (includes profile fallback)
    final selectedBatch = ref.watch(resolvedBatchProvider);
    final selectedSemester = ref.watch(selectedSemesterNotifierProvider);

    // Only fetch student profile in student mode (no departmentId means student context)

    final chaptersAsync = ref.watch(
      chaptersForCourseProvider(
        universityId: widget.courseModel.universityId,
        departmentId: widget.courseModel.departmentId,
        courseCode: widget.courseModel.courseCode,
        batchId: isAllBatches(selectedBatch) ? null : selectedBatch?.id,
      ),
    );

    return Scaffold(
      body: Expanded(
        child: chaptersAsync.when(
          data: (chapters) {
            // Local filter as fallback if API filter wasn't precise enough
            final filteredChapters = chapters.where((c) {
              if (isAllBatches(selectedBatch)) return true;
              final batchId = selectedBatch!.id;
              return c.batches.isEmpty || c.batches.contains(batchId);
            }).toList();

            if (filteredChapters.isEmpty) {
              return const Center(child: Text('No Chapters Found!'));
            }

            return ListView.separated(
              shrinkWrap: true,
              itemCount: filteredChapters.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemBuilder: (context, index) {
                final chapterModel = filteredChapters[index];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.cardColor,
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.blueGrey.shade50,
                      width: .5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      context.push(
                        Uri(
                          path: AppRoute.courseNotes.toPath({
                            'courseCode': widget.courseModel.courseCode,
                            'chapterNo': chapterModel.chapterNo.toString(),
                          }),
                          queryParameters: {
                            'title': chapterModel.chapterTitle,
                            if (selectedBatch != null)
                              'batch': selectedBatch.name,
                            if (selectedSemester != null)
                              'semester': selectedSemester.name,
                            if (widget.universityId != null)
                              'universityId': widget.universityId,
                            if (widget.departmentId != null)
                              'departmentId': widget.departmentId,
                          },
                        ).toString(),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: isDark
                                  ? theme.colorScheme.surface.withValues(alpha: 0.5)
                                  : Colors.grey.shade100,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${chapterModel.chapterNo}',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              chapterModel.chapterTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
      floatingActionButton: null,
    );
  }

}
