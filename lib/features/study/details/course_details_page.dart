import 'package:campusassistant/widgets/breadcrumbs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:campusassistant/features/course/presentation/providers/course_provider.dart';
import 'package:campusassistant/features/course/presentation/providers/course_state_provider.dart';
import 'package:campusassistant/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:campusassistant/features/batch/domain/entities/batch.dart';
import 'package:campusassistant/features/batch/presentation/providers/selected_batch_provider.dart';
import 'package:campusassistant/features/batch/presentation/providers/batch_list_provider.dart';
import 'package:campusassistant/features/study/semester/presentation/providers/semester_provider.dart';
import '/core/widgets/section_tab_bar.dart';
import '/utils/constants.dart';
import 'course_chapters_page.dart';
import 'course_types_details.dart';
import 'course_videos_page.dart';

class CourseDetailsScreen extends ConsumerStatefulWidget {
  final String courseCode;
  final String? batch;
  final String? semester;
  final String? initialTabName;

  const CourseDetailsScreen({
    super.key,
    required this.courseCode,
    this.batch,
    this.semester,
    this.initialTabName,
  });

  @override
  ConsumerState<CourseDetailsScreen> createState() =>
      _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends ConsumerState<CourseDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Guard: URL params synced exactly once per page instantiation.
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    // Tab index
    int initialIndex = ref.read(selectedCourseTabProvider) ?? 0;
    if (widget.initialTabName != null) {
      final urlIndex = kCourseType.indexWhere(
        (tab) => tab.toLowerCase() == widget.initialTabName!.toLowerCase(),
      );
      if (urlIndex != -1) initialIndex = urlIndex;
    }

    _tabController = TabController(
      length: kCourseType.length,
      vsync: this,
      initialIndex: initialIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final newIndex = _tabController.index;
        final tabName = kCourseType[newIndex].toLowerCase();
        ref.read(selectedCourseTabProvider.notifier).setTab(newIndex);

        final state = GoRouterState.of(context);
        final currentTab = state.uri.queryParameters['tab']?.toLowerCase();
        if (currentTab != tabName) {
          context.replaceNamed(
            'courseDetails',
            pathParameters: {'courseCode': widget.courseCode},
            queryParameters: {
              if (widget.batch != null) 'batch': widget.batch!,
              if (widget.semester != null) 'semester': widget.semester!,
              'tab': tabName,
            },
          );
        }
      }
    });

    // Sync URL params once after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncFromUrl());
  }

  /// Read URL params and set global state ONCE.
  /// This is a one-shot operation — the _initialized guard prevents it
  /// from running on any subsequent rebuild.
  void _syncFromUrl() {
    if (_initialized || !mounted) return;
    _initialized = true;

    // -- Sync Batch --
    if (widget.batch != null && widget.batch!.isNotEmpty) {
      final currentBatch = ref.read(resolvedBatchProvider);
      final alreadyMatches =
          currentBatch?.id == widget.batch ||
          currentBatch?.slug == widget.batch ||
          currentBatch?.name == widget.batch;

      if (!alreadyMatches) {
        final batches = ref.read(batchProviderStudy).value;
        if (batches != null) {
          final match = batches
              .where(
                (b) =>
                    b.id == widget.batch ||
                    b.slug == widget.batch ||
                    b.name == widget.batch,
              )
              .firstOrNull;
          if (match != null) {
            ref
                .read(selectedBatchNotifierProvider.notifier)
                .setSelectedBatch(match);
          }
        }
      }
    }

    // -- Sync Semester --
    if (widget.semester != null && widget.semester!.isNotEmpty) {
      final currentSemester = ref.read(selectedSemesterNotifierProvider);
      final alreadyMatches =
          currentSemester?.name == widget.semester ||
          currentSemester?.id == widget.semester;

      if (!alreadyMatches) {
        final semesters = ref.read(semestersProvider).value;
        if (semesters != null) {
          final match = semesters
              .where(
                (s) => s.name == widget.semester || s.id == widget.semester,
              )
              .firstOrNull;
          if (match != null) {
            ref
                .read(selectedSemesterNotifierProvider.notifier)
                .setFromSemester(match);
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userAsync = ref.watch(userProvider);
    final selectedBatch = ref.watch(resolvedBatchProvider);
    final batchesAsync = ref.watch(batchProviderStudy);

    return userAsync.when(
      data: (user) {
        final courseAsync = ref.watch(
          courseByCodeProvider(
            universityId: user.information.universityId ?? '',
            departmentId: user.information.departmentId ?? '',
            courseCode: widget.courseCode,
          ),
        );

        return courseAsync.when(
          data: (courseModel) {
            if (courseModel == null) {
              return const Scaffold(
                body: Center(child: Text('Course not found')),
              );
            }

            final safeCourseCode = courseModel.courseCode;
            final safeCourseTitle = courseModel.courseTitle;
            final primaryRed = const Color(0xFFD32F2F);

            return Scaffold(
              backgroundColor: primaryRed,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  '$safeCourseCode : $safeCourseTitle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: SizedBox.shrink(),
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Breadcrumbs (red area, above white container) ────
                  Theme(
                    data: theme.copyWith(
                      colorScheme: theme.colorScheme.copyWith(
                        onSurface: Colors.white,
                        onSurfaceVariant: Colors.white70,
                      ),
                    ),
                    child: const Breadcrumbs(),
                  ),

                  // ── Filter row (red area) ────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
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
                        batchesAsync.when(
                          data: (batches) {
                            if (batches.isEmpty) return const SizedBox();
                            return _BatchButton(
                              batches: batches,
                              selectedBatch: selectedBatch,
                              redBg: true,
                            );
                          },
                          loading: () => const SizedBox(
                            width: 100,
                            height: 32,
                            child: Center(
                              child: CupertinoActivityIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          error: (_, _) => const SizedBox(),
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
                            // ── SectionTabBar ──────────────────────────
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: SectionTabBar(
                                controller: _tabController,
                                isScrollable: true,
                                tabs: kCourseType
                                    .map((tab) => Tab(text: tab))
                                    .toList(),
                              ),
                            ),

                            // ── Tab content ──────────────────────────
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  CourseChaptersScreen(
                                    courseType: kCourseType[0],
                                    courseModel: courseModel,
                                    batch: widget.batch,
                                    semester: widget.semester,
                                  ),
                                  CourseVideos(
                                    courseModel: courseModel,
                                    batch: widget.batch,
                                    semester: widget.semester,
                                  ),
                                  CourseTypesDetails(
                                    courseType: kCourseType[2],
                                    courseModel: courseModel,
                                    batch: widget.batch,
                                    semester: widget.semester,
                                  ),
                                  CourseTypesDetails(
                                    courseType: kCourseType[3],
                                    courseModel: courseModel,
                                    batch: widget.batch,
                                    semester: widget.semester,
                                  ),
                                  CourseTypesDetails(
                                    courseType: kCourseType[4],
                                    courseModel: courseModel,
                                    batch: widget.batch,
                                    semester: widget.semester,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) =>
              Scaffold(body: Center(child: Text('Course Error: $e'))),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('User Error: $e'))),
    );
  }
}

// ── _BatchButton — opens a batch bottom sheet, like study_page ────────
class _BatchButton extends ConsumerWidget {
  final List<Batch> batches;
  final Batch? selectedBatch;
  final bool redBg;

  const _BatchButton({
    required this.batches,
    required this.selectedBatch,
    this.redBg = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showBatchSheet(context, ref),
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
            Text(
              selectedBatch?.name ?? 'All Batches',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: redBg ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: redBg ? Colors.white : theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  void _showBatchSheet(BuildContext context, WidgetRef ref) {
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
            final filteredBatches = searchText.isEmpty
                ? batches
                : batches
                      .where(
                        (b) => b.name.toLowerCase().contains(
                          searchText.toLowerCase(),
                        ),
                      )
                      .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
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
                          'Select Batch',
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
                          hintText: 'Search batch...',
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
                  // Batch list
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        if (searchText.isEmpty)
                          _BatchTile(
                            title: 'All Batches',
                            isSelected: selectedBatch == null,
                            onTap: () {
                              ref
                                  .read(selectedBatchNotifierProvider.notifier)
                                  .setAll();
                              Navigator.pop(context);
                            },
                          ),
                        ...filteredBatches.map(
                          (b) => _BatchTile(
                            title: b.name,
                            isSelected: selectedBatch?.id == b.id,
                            onTap: () {
                              ref
                                  .read(selectedBatchNotifierProvider.notifier)
                                  .setSelectedBatch(b);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
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

// ── _BatchTile — selectable batch row ───────────────────────────────────
class _BatchTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _BatchTile({
    required this.title,
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
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: isSelected
                    ? (isDark ? Colors.red.shade300 : Colors.red.shade700)
                    : (isDark ? Colors.white : Colors.black87),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
