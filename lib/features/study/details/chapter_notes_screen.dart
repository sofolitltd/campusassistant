import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '../semester/presentation/providers/semester_provider.dart';
import 'package:campusassistant/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/resource/presentation/widgets/resource_card.dart';
import '/routes/app_route.dart';
import '../../../widgets/breadcrumbs.dart';

class CourseNotesScreens extends ConsumerStatefulWidget {
  const CourseNotesScreens({
    super.key,
    required this.courseCode,
    required this.chapterNo,
    required this.title,
    required this.batch,
    required this.semester,
    this.universityId,
    this.departmentId,
  });

  final String courseCode;
  final String chapterNo;
  final String? title;
  final String? batch;
  final String? semester;
  final String? universityId;
  final String? departmentId;

  @override
  ConsumerState<CourseNotesScreens> createState() => _CourseNotesScreensState();
}

class _CourseNotesScreensState extends ConsumerState<CourseNotesScreens> {
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

  Future<void> _handleDelete(WidgetRef ref, dynamic resource) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text(
          'Are you sure you want to delete this note?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(resourceRepositoryProvider).deleteResource(resource.id);
      ref.invalidate(resourcesListProvider);
      Fluttertoast.showToast(msg: 'Note deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final universityId =
        widget.universityId ?? userAsync.value?.information.universityId ?? '';
    final departmentId =
        widget.departmentId ?? userAsync.value?.information.departmentId ?? '';
    final isModerator = userAsync.value?.information.status?.moderator ?? false;
    final isAdmin = userAsync.value?.information.status?.admin ?? false;

    // Use reactive selection
    final selectedBatch = ref.watch(resolvedBatchProvider);

    final isCrForCurrentBatch =
        userAsync.value != null &&
        userAsync.value!.information.status?.cr == true &&
        userAsync.value!.information.batch == selectedBatch?.name;

    final canEdit =
        widget.departmentId != null ||
        isAdmin ||
        isModerator ||
        isCrForCurrentBatch;

    final params = (
      universityId: universityId,
      departmentId: departmentId,
      type: 'note',
      courseCode: widget.courseCode,
      batch: null,
      batchId: selectedBatch?.id,
      lessonNo: int.tryParse(widget.chapterNo) ?? 0,
      uploaderUid: null,
      status: null,
    );

    final notesStream = ref.watch(resourcesListProvider(
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
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          '${widget.chapterNo}. ${widget.title}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.departmentId == null) const Breadcrumbs(),
          const SizedBox(height: 10),

          Expanded(
            child: notesStream.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (resources) {
                if (resources.isEmpty) {
                  return const Center(child: Text('No notes found!'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  itemCount: resources.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final resource = resources[index];
                    return ResourceCard(
                      resource: resource,
                      onEdit: !canEdit
                          ? null
                          : () {
                              context.push(
                                AppRoute.editResource.toPath({
                                  'universityId': params.universityId,
                                  'departmentId': params.departmentId,
                                  'courseCode': widget.courseCode,
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
            ),
          ),
        ],
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () {
                context.push(
                  Uri(
                    path: AppRoute.addResource.toPath({
                      'universityId': universityId,
                      'departmentId': departmentId,
                      'courseCode': widget.courseCode,
                    }),
                    queryParameters: {
                      'type': 'note',
                      'lessonNo': widget.chapterNo,
                      if (selectedBatch != null)
                        'initialBatchName': selectedBatch.name,
                    },
                  ).toString(),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
