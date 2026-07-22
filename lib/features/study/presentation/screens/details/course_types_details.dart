import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/ads/ad_list_helper.dart';
import '/features/course/domain/entities/course.dart';
import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/utils/constants.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/study/levels/presentation/providers/semester_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/resource/presentation/widgets/resource_card.dart';
import '/routes/app_route.dart';

class CourseTypesDetails extends ConsumerStatefulWidget {
  const CourseTypesDetails({
    super.key,
    required this.courseType, // Used as collection name
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
  ConsumerState<CourseTypesDetails> createState() => _CourseTypesDetailsState();
}

class _CourseTypesDetailsState extends ConsumerState<CourseTypesDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncSelectionWithParams();
    });
  }

  void _syncSelectionWithParams() {
    // Sync batch if passed in URL
    if (widget.batch != null && widget.batch!.isNotEmpty) {
      final batchesAsync = ref.read(batchProviderStudy);
      final batches = batchesAsync.value;
      if (batches != null) {
        final match = batches
            .where(
              (b) =>
                  b.id == widget.batch ||
                  b.name == widget.batch ||
                  b.slug == widget.batch,
            )
            .firstOrNull;
        if (match != null) {
          ref
              .read(selectedBatchNotifierProvider.notifier)
              .setSelectedBatch(match);
        }
      }
    }

    // Sync semester if passed in URL
    if (widget.semester != null && widget.semester!.isNotEmpty) {
      final currentSelected = ref.read(selectedSemesterNotifierProvider);
      if (currentSelected?.name != widget.semester) {
        final semestersAsync = ref.read(semestersProvider);
        semestersAsync.whenData((list) {
          final match = list
              .where((s) => s.name == widget.semester)
              .firstOrNull;
          if (match != null) {
            ref
                .read(selectedSemesterNotifierProvider.notifier)
                .setFromSemester(match);
          }
        });
      }
    }
  }

  // Admin mode when called from AdminCourseDetailsScreen (departmentId is passed)
  bool get _isAdminMode => widget.departmentId != null;

  /// Maps the display tab name to the backend `type` field value.
  String get _resourceType {
    switch (widget.courseType.toLowerCase()) {
      case 'books':
        return 'book';
      case 'questions':
        return 'question';
      case 'syllabus':
        return 'syllabus';
      case 'notes':
        return 'note';
      default:
        return widget.courseType.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userAsync = ref.watch(userProvider);

    // Only filter by batch when user explicitly chose one
    final explicitBatch = ref.watch(selectedBatchNotifierProvider);
    final resolvedBatch = ref.watch(resolvedBatchProvider);
    final effectiveBatch = explicitBatch != null ? resolvedBatch : null;

    final params = (
      universityId: widget.universityId ?? widget.courseModel.universityId,
      departmentId: widget.departmentId ?? widget.courseModel.departmentId,
      type: _resourceType,
      courseCode: widget.courseModel.courseCode,
      batch: isAllBatches(effectiveBatch) ? null : effectiveBatch?.name,
      batchId: isAllBatches(effectiveBatch) ? null : effectiveBatch?.id,
      lessonNo: null,
      uploaderUid: null,
      status: null,
      limit: kDefaultPageSize,
    );

    final contentAsync = ref.watch(
      resourcesListProvider(
        universityId: params.universityId,
        departmentId: params.departmentId,
        type: params.type,
        courseCode: params.courseCode,
        batch: params.batch,
        batchId: params.batchId,
        lessonNo: params.lessonNo,
        uploaderUid: params.uploaderUid,
        status: params.status,
        limit: params.limit,
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: contentAsync.when(
              data: (resources) {
                if (resources.isEmpty) {
                  return Center(child: Text('No ${widget.courseType} found!'));
                }

                final adList = withPeriodicAds(
                  realCount: resources.length,
                  realItemBuilder: (context, index) {
                    final resource = resources[index];
                    return ResourceCard(resource: resource);
                  },
                );

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  itemCount: adList.itemCount,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: adList.itemBuilder,
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context, ref, resolvedBatch, params),
    );
  }

  Widget? _buildFAB(
    BuildContext context,
    WidgetRef ref,
    Batch? selectedBatch,
    dynamic params,
  ) {
    final userAsync = ref.read(userProvider);
    final isModerator = userAsync.value?.information.status?.moderator ?? false;
    final isAdmin = userAsync.value?.information.status?.admin ?? false;
    final isCr = userAsync.value?.information.status?.cr ?? false;

    if (!(_isAdminMode || isAdmin || isModerator || isCr)) return null;

    return FloatingActionButton(
      onPressed: () {
        context.push(
          Uri(
            path: AppRoute.addResource.toPath({
              'universityId': params.universityId,
              'departmentId': params.departmentId,
              'courseCode': widget.courseModel.courseCode,
            }),
            queryParameters: {
              'type': _resourceType,
              if (selectedBatch != null) 'initialBatchName': selectedBatch.name,
            },
          ).toString(),
        );
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
