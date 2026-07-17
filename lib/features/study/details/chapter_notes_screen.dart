import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';

import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/chapter/presentation/providers/chapter_provider.dart';
import '/features/chapter/domain/entities/chapter.dart';
import '../levels/presentation/providers/semester_provider.dart';
import '/core/theme/app_colors.dart';
import '/utils/constants.dart';

import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/resource/presentation/widgets/resource_card.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_tab_bar.dart';

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
    final userAsync = ref.watch(userProvider);
    final universityId = widget.universityId ?? '';
    final departmentId = widget.departmentId ?? '';
    final isModerator = userAsync.value?.information.status?.moderator ?? false;
    final isAdmin = userAsync.value?.information.status?.admin ?? false;

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
                _ChapterFilterButton(
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
                              return ResourceCard(resource: resource);
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

// ── _ChapterFilterButton — chapter filter dropdown ───────────────────
class _ChapterFilterButton extends ConsumerWidget {
  final AsyncValue<List<Chapter>> chaptersAsync;
  final String selectedChapterNo;
  final Function(Chapter) onChapterSelected;
  final bool redBg;

  const _ChapterFilterButton({
    required this.chaptersAsync,
    required this.selectedChapterNo,
    required this.onChapterSelected,
    this.redBg = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return chaptersAsync.when(
      data: (chapters) {
        if (chapters.isEmpty) return const SizedBox();

        final selectedChapter = chapters.firstWhere(
          (c) => c.chapterNo.toString() == selectedChapterNo,
          orElse: () => chapters.first,
        );

        return GestureDetector(
          onTap: () => _showChapterSheet(context, chapters),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  'Chapter',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: redBg ? Colors.white : theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${selectedChapter.chapterNo}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: redBg ? Colors.white : theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
      },
      loading: () => const SizedBox(
        width: 100,
        height: 32,
        child: Center(child: CupertinoActivityIndicator(color: Colors.white)),
      ),
      error: (_, _) => const SizedBox(),
    );
  }

  void _showChapterSheet(BuildContext context, List<Chapter> chapters) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
            final filteredChapters = searchText.isEmpty
                ? chapters
                : chapters
                      .where(
                        (c) =>
                            c.chapterTitle.toLowerCase().contains(
                              searchText.toLowerCase(),
                            ) ||
                            c.chapterNo.toString().contains(searchText),
                      )
                      .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
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
                  // Title row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Chapter',
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
                  // Search field
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
                          hintText: 'Search chapter...',
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
                  // Chapter list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filteredChapters.length,
                      itemBuilder: (context, index) {
                        final chapter = filteredChapters[index];
                        final isSelected =
                            chapter.chapterNo.toString() == selectedChapterNo;

                        return _ChapterTile(
                          chapter: chapter,
                          isSelected: isSelected,
                          onTap: () {
                            onChapterSelected(chapter);
                            Navigator.pop(context);
                          },
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

// ── _ChapterTile — selectable chapter row ───────────────────────────
class _ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChapterTile({
    required this.chapter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? Colors.red.shade900.withAlpha(50)
                    : const Color(0xFFFDE8E8))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chapter ${chapter.chapterNo}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? (isDark ? Colors.red.shade300 : Colors.red.shade700)
                          : (isDark ? Colors.white54 : Colors.grey.shade600),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    chapter.chapterTitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected
                          ? (isDark ? Colors.red.shade300 : Colors.red.shade700)
                          : (isDark ? Colors.white : Colors.black87),
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
                color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
