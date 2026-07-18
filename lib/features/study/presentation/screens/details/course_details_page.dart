
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/features/course/presentation/providers/course_provider.dart';
import '/features/course/presentation/providers/course_state_provider.dart';
import '/features/course/domain/entities/course.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/study/levels/presentation/providers/semester_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/widgets/section_tab_bar.dart';
import '/utils/constants.dart';
import '/features/study/widgets/batch_dropdown.dart';
import '/features/study/presentation/widgets/details/semester_filter_button.dart';
import '/features/study/presentation/widgets/details/course_filter_button.dart';
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
        final batches = ref.read(batchProviderAll).value;
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
    final selectedSemester = ref.watch(selectedSemesterNotifierProvider);
    final semestersAsync = ref.watch(filteredSemestersProvider);

    // Courses for current batch/semester (for course filter)
    final uid = userAsync.value?.information.universityId ?? '';
    final did = userAsync.value?.information.departmentId ?? '';
    final coursesAsync = ref.watch(
      coursesProvider(
        universityId: uid,
        departmentId: did,
        semesterId: selectedSemester?.id,
        batchId: isAllBatches(selectedBatch) ? null : selectedBatch?.id,
      ),
    );

    // Course data (may be loading)
    final user = userAsync.value;
    final courseAsync = user != null
        ? ref.watch(
            courseByCodeProvider(
              universityId: user.information.universityId ?? '',
              departmentId: user.information.departmentId ?? '',
              courseCode: widget.courseCode,
              batchId: isAllBatches(selectedBatch) ? null : selectedBatch?.id,
              semesterId: selectedSemester?.id,
            ),
          )
        : const AsyncLoading<Course?>();

    final courseModel = courseAsync.value;
    final isLoading = userAsync.isLoading || courseAsync.isLoading;
    final hasError = userAsync.hasError || courseAsync.hasError;

    final primaryColor = Theme.of(context).appColors.primaryColor;
    final appBarTitle = courseModel != null
        ? '${courseModel.courseCode.toUpperCase()} : ${courseModel.courseTitle}'
        : widget.courseCode.toUpperCase();

    // ── Error state ──────────────────────────────────────────────────
    if (hasError && !isLoading) {
      final errorMsg = userAsync.error ?? courseAsync.error;
      return Scaffold(
        backgroundColor: primaryColor,
        body: Center(
          child: Text(
            'Error: $errorMsg',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

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
          appBarTitle,
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
          // ── Filter row (red area) ────────────────────────────
          Padding(
            padding: const .fromLTRB(16, 0, 0, 16),
            child: Row(
              children: [
                const Text(
                  'Filter:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Batch filter button (first)
                        const BatchDropdown(redBg: true),
                        const SizedBox(width: 8),
                        // Semester/Year filter button (second)
                        SemesterFilterButton(
                          selectedSemester: selectedSemester,
                          semesters: semestersAsync,
                          redBg: true,
                        ),
                        const SizedBox(width: 8),
                        // Course filter button (third)
                        coursesAsync.when(
                          data: (courses) {
                            if (courses.isEmpty) return const SizedBox();
                            return CourseFilterButton(
                              courses: courses,
                              selectedCourseCode: widget.courseCode,
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
                child: courseModel == null
                    ? const Center(child: CupertinoActivityIndicator())
                    : Column(
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
  }
}
