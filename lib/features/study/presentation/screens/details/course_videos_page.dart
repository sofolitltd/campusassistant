import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:go_router/go_router.dart';

import '/features/course/domain/entities/course.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/study/levels/presentation/providers/semester_provider.dart';
import '/routes/app_route.dart';
import '/utils/constants.dart';
import '/core/theme/tokens/app_radius.dart';

class CourseVideos extends ConsumerStatefulWidget {
  const CourseVideos({
    super.key,
    required this.courseModel,
    this.universityId,
    this.departmentId,
    this.batch,
    this.semester,
  });

  final Course courseModel;
  final String? universityId;
  final String? departmentId;
  final String? batch;
  final String? semester;

  @override
  ConsumerState<CourseVideos> createState() => _CourseVideosState();
}

class _CourseVideosState extends ConsumerState<CourseVideos> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userAsync = ref.watch(userProvider);
    // Only filter by batch when user explicitly chose one
    final explicitBatch = ref.watch(selectedBatchNotifierProvider);
    final selectedBatch = ref.watch(resolvedBatchProvider);
    final effectiveBatch = explicitBatch != null ? selectedBatch : null;

    final params = (
      universityId: widget.universityId ?? widget.courseModel.universityId,
      departmentId: widget.departmentId ?? widget.courseModel.departmentId,
      type: 'video',
      courseCode: widget.courseModel.courseCode,
      batch: isAllBatches(effectiveBatch) ? null : effectiveBatch?.name,
      batchId: isAllBatches(effectiveBatch) ? null : effectiveBatch?.id,
      lessonNo: null,
      uploaderUid: null,
      status: null,
      limit: kDefaultPageSize,
    );

    final videosAsync = ref.watch(
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

    final isModerator = userAsync.value?.information.status?.moderator ?? false;
    final isCrForCurrentBatch =
        userAsync.value != null &&
        userAsync.value!.information.status?.cr == true &&
        userAsync.value!.information.batch == selectedBatch?.name;

    final canEdit =
        widget.departmentId != null || isModerator || isCrForCurrentBatch;

    Future<void> deleteVideo(String docId) async {
      final result = await ref
          .read(resourceRepositoryProvider)
          .deleteResource(docId);
      result.fold(
        (l) =>
            Fluttertoast.showToast(msg: 'Failed to delete video: ${l.message}'),
        (r) {
          Fluttertoast.showToast(msg: 'Video deleted successfully');
          ref.invalidate(resourcesListProvider);
        },
      );
    }

    return Scaffold(
      body: videosAsync.when(
        data: (resources) {
          if (resources.isEmpty) {
            return const Center(child: Text('No videos found!'));
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: resources.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 12),
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final resource = resources[index];
              final videoId =
                  YoutubePlayer.convertUrlToId(resource.fileUrl) ?? '';
              final thumb = YoutubePlayer.getThumbnail(videoId: videoId);
              final title = resource.title;
              final subtitle = resource.description;
              final chapterNo = resource.lessonNo.toString();

              return Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(RadiusToken.md),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.blueGrey.shade50,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                  onTap: () {
                    if (videoId.isNotEmpty) {
                      context.push(
                        Uri(
                          path: AppRoute.youtubePlayer.toPath({
                            'videoId': videoId,
                          }),
                          queryParameters: {'title': title},
                        ).toString(),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 90,
                            width: 120,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              child: Image.network(
                                thumb,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: isDark
                                          ? theme.colorScheme.surface
                                                .withValues(alpha: 0.5)
                                          : Colors.grey.shade100,
                                      child: Icon(
                                        LucideIcons.video,
                                        color: isDark
                                            ? Colors.white38
                                            : Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.play,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          height: 90,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$chapterNo. $title',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.grey,
                                        ),
                                  ),
                                ],
                              ),
                              if (canEdit)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context.push(
                                          AppRoute.editResource.toPath({
                                            'universityId': params.universityId,
                                            'departmentId': params.departmentId,
                                            'courseCode':
                                                widget.courseModel.courseCode,
                                            'resourceId': resource.id,
                                          }),
                                          extra: resource,
                                        );
                                      },
                                      child: const Icon(
                                        LucideIcons.pencil,
                                        color: Colors.blue,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Video'),
                                            content: const Text(
                                              'Are you sure you want to delete this video?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          deleteVideo(resource.id);
                                        }
                                      },
                                      child: const Icon(
                                        LucideIcons.trash2,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, stack) =>
            const Center(child: Text('Error loading videos.')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(
            Uri(
              path: AppRoute.addResource.toPath({
                'universityId': params.universityId,
                'departmentId': params.departmentId,
                'courseCode': widget.courseModel.courseCode,
              }),
              queryParameters: {
                'type': 'video',
                'lessonNo': '1',
                if (selectedBatch != null)
                  'initialBatchName': selectedBatch.name,
              },
            ).toString(),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
