import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/features/course/domain/entities/course.dart';
import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/resource/domain/entities/resource.dart';
import '../semester/presentation/providers/semester_provider.dart';
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
    final userAsync = ref.watch(userProvider);
    final userUId = userAsync.value?.information.universityId ?? '';
    final userDId = userAsync.value?.information.departmentId ?? '';

    // Enterprise Reactive Selection: Fallback to profile if not overridden
    final selectedBatch = ref.watch(resolvedBatchProvider);

    final params = (
      universityId: widget.universityId ?? userUId,
      departmentId: widget.departmentId ?? userDId,
      type: _resourceType,
      courseCode: widget.courseModel.courseCode,
      batch: isAllBatches(selectedBatch) ? null : selectedBatch?.name,
      batchId: isAllBatches(selectedBatch) ? null : selectedBatch?.id,
      lessonNo: null,
      uploaderUid: null,
      status: null,
    );

    final contentAsync = ref.watch(resourcesListProvider(
      universityId: params.universityId,
      departmentId: params.departmentId,
      type: params.type,
      courseCode: params.courseCode,
      batch: params.batch,
      batchId: params.batchId,
      lessonNo: params.lessonNo,
      uploaderUid: params.uploaderUid,
      status: params.status,
    ));

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: contentAsync.when(
              data: (resources) {
                if (resources.isEmpty) {
                  return Center(child: Text('No ${widget.courseType} found!'));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  itemCount: resources.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final resource = resources[index];

                    final isModerator =
                        userAsync.value?.information.status?.moderator ?? false;
                    final isAdmin =
                        userAsync.value?.information.status?.admin ?? false;
                    final isCrForCurrentBatch =
                        userAsync.value != null &&
                        userAsync.value!.information.status?.cr == true &&
                        userAsync.value!.information.batch ==
                            selectedBatch?.name;

                    final canEdit =
                        _isAdminMode ||
                        isAdmin ||
                        isModerator ||
                        isCrForCurrentBatch;

                    return ResourceCard(
                      resource: resource,
                      onEdit: !canEdit
                          ? null
                          : () {
                              context.push(
                                AppRoute.editResource.toPath({
                                  'universityId': params.universityId,
                                  'departmentId': params.departmentId,
                                  'courseCode': widget.courseModel.courseCode,
                                  'resourceId': resource.id,
                                }),
                                extra: resource,
                              );
                            },
                      onDelete: !canEdit
                          ? null
                          : () => _handleDelete(ref, resource),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context, ref, selectedBatch, params),
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

  Future<void> _handleDelete(WidgetRef ref, Resource resource) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resource'),
        content: const Text('Are you sure you want to delete this resource?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(resourceRepositoryProvider).deleteResource(resource.id);
      ref.invalidate(resourcesListProvider);
      Fluttertoast.showToast(msg: 'Resource deleted');
    }
  }
}
