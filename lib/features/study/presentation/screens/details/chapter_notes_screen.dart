import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';

import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/chapter/presentation/providers/chapter_provider.dart';
import '/features/chapter/domain/entities/chapter.dart';
import '/features/study/levels/presentation/providers/semester_provider.dart';
import '/core/theme/app_colors.dart';
import '/utils/constants.dart';

import '/features/resource/presentation/widgets/resource_card.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_tab_bar.dart';
import '/features/study/presentation/widgets/details/chapter_filter_button.dart';

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
    this.resourceId,
  });

  final String courseCode;
  final String chapterNo;
  final String? title;
  final String? batch;
  final String? semester;
  final String? universityId;
  final String? departmentId;

  /// When set (e.g. from a "new resource" notification deep link), the
  /// matching resource in the list auto-opens once it loads.
  final String? resourceId;

  @override
  ConsumerState<CourseNotesScreens> createState() => _CourseNotesScreensState();
}

class _CourseNotesScreensState extends ConsumerState<CourseNotesScreens>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;
  String? _selectedChapterNo;

  @override
  void initState() {
    super.initState();
    _selectedChapterNo = widget.chapterNo;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentTab = _tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncSelectionWithParams();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  void _navigateToChapter(Chapter chapter) {
    setState(() {
      _selectedChapterNo = chapter.chapterNo.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final universityId = widget.universityId ?? '';
    final departmentId = widget.departmentId ?? '';
    // final userAsync = ref.watch(userProvider);
    // final isModerator = userAsync.value?.information.status?.moderator ?? false;
    // final isAdmin = userAsync.value?.information.status?.admin ?? false;

    // Use reactive selection
    final selectedBatch = ref.watch(resolvedBatchProvider);

    // Fetch chapters for this course
    final chaptersAsync = ref.watch(
      chaptersForCourseProvider(
        universityId: universityId,
        departmentId: departmentId,
        courseCode: widget.courseCode,
        batchId: selectedBatch?.id,
      ),
    );

    // Derive selected chapter title
    final chaptersList = chaptersAsync.value;
    final chapterTitle = chaptersList != null
        ? chaptersList
              .firstWhere(
                (c) =>
                    c.chapterNo.toString() ==
                    (_selectedChapterNo ?? widget.chapterNo),
                orElse: () => chaptersList.first,
              )
              .chapterTitle
        : '';

    // final isCrForCurrentBatch =
    //     userAsync.value != null &&
    //     userAsync.value!.information.status?.cr == true &&
    //     userAsync.value!.information.batch == selectedBatch?.name;

    // final canEdit =
    //     widget.departmentId != null ||
    //     isAdmin ||
    //     isModerator ||
    //     isCrForCurrentBatch;

    final params = (
      universityId: universityId,
      departmentId: departmentId,
      type: _currentTab == 0 ? 'note' : 'video',
      courseCode: widget.courseCode,
      batch: null,
      batchId: selectedBatch?.id,
      lessonNo: int.tryParse(_selectedChapterNo ?? widget.chapterNo) ?? 0,
      uploaderUid: null,
      status: null,
      limit: kDefaultPageSize,
    );

    final resourcesStream = ref.watch(
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

    final primaryColor = Theme.of(context).appColors.primaryColor;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          chapterTitle.isNotEmpty
              ? 'Chapter ${_selectedChapterNo ?? widget.chapterNo}: $chapterTitle'
              : 'Chapter ${_selectedChapterNo ?? widget.chapterNo}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filter row (red area) ──────────────────────────
          Padding(
                        padding: const .fromLTRB(16, 0, 16, 16),

            child: Row(
              children: [
                const Text(
                  'Filter:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                ChapterFilterButton(
                  chaptersAsync: chaptersAsync,
                  selectedChapterNo: _selectedChapterNo ?? widget.chapterNo,
                  onChapterSelected: _navigateToChapter,
                  redBg: true,
                ),
              ],
            ),
          ),

          // ── White rounded container ──────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.scaffoldBackgroundColor
                    : const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Column(
                  children: [
                    // ── SectionTabBar (inside container) ────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: SectionTabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Notes'),
                          Tab(text: 'Videos'),
                        ],
                      ),
                    ),

                    // ── Tab content ──────────────────────────────
                    Expanded(
                      child: resourcesStream.when(
                        loading: () =>
                            const Center(child: CupertinoActivityIndicator()),
                        error: (e, _) => Center(child: Text('Error: $e')),
                        data: (resources) {
                          if (resources.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _currentTab == 0
                                        ? Icons.description_outlined
                                        : Icons.videocam_outlined,
                                    size: 64,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: Spacing.lg),
                                  Text(
                                    _currentTab == 0
                                        ? 'No notes found!'
                                        : 'No videos found!',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _currentTab == 0
                                        ? 'Upload lecture notes for this chapter'
                                        : 'Add video lectures for this chapter',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: resources.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: Spacing.md),
                            itemBuilder: (context, index) {
                              final resource = resources[index];
                              return ResourceCard(
                                resource: resource,
                                autoOpen: widget.resourceId != null &&
                                    resource.id == widget.resourceId,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      //todo: later add this feature
      // floatingActionButton: canEdit
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           context.push(
      //             Uri(
      //               path: AppRoute.addResource.toPath({
      //                 'universityId': universityId,
      //                 'departmentId': departmentId,
      //                 'courseCode': widget.courseCode,
      //               }),
      //               queryParameters: {
      //                 'type': _currentTab == 0 ? 'note' : 'video',
      //                 'lessonNo': _selectedChapterNo ?? widget.chapterNo,
      //                 if (selectedBatch != null)
      //                   'initialBatchName': selectedBatch.name,
      //               },
      //             ).toString(),
      //           );
      //         },
      //         backgroundColor: primaryColor,
      //         child: const Icon(Icons.add, color: Colors.white),
      //       )
      //     : null,
    );
  }
}
