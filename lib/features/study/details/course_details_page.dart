
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/course/presentation/providers/course_provider.dart';
import '/features/course/presentation/providers/course_state_provider.dart';
import '/features/course/domain/entities/course.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '../levels/presentation/providers/semester_provider.dart';
import '../levels/domain/entities/semester.dart';
import '/core/theme/app_colors.dart';
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
    final batchesAsync = ref.watch(batchProviderStudy);
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
                        const SizedBox(width: 8),
                        // Semester/Year filter button (second)
                        _SemesterFilterButton(
                          selectedSemester: selectedSemester,
                          semesters: semestersAsync,
                          redBg: true,
                        ),
                        const SizedBox(width: 8),
                        // Course filter button (third)
                        coursesAsync.when(
                          data: (courses) {
                            if (courses.isEmpty) return const SizedBox();
                            return _CourseFilterButton(
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

// ── _SemesterFilterButton — semester filter dropdown ───────────────────
class _SemesterFilterButton extends ConsumerWidget {
  final SelectedSemester? selectedSemester;
  final List<Semester> semesters;
  final bool redBg;

  const _SemesterFilterButton({
    required this.selectedSemester,
    required this.semesters,
    this.redBg = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showSemesterSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
              LucideIcons.graduationCap,
              size: 14,
              color: redBg ? Colors.white : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              selectedSemester?.name ?? 'Level',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: redBg ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            if (selectedSemester != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  ref.read(selectedSemesterNotifierProvider.notifier).clear();
                },
                child: Icon(
                  LucideIcons.circleX,
                  size: 12,
                  color: redBg ? Colors.white70 : Colors.red.shade700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSemesterSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
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
                      'Select Level',
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
              // Semester list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _SemesterTile(
                      title: 'All Levels',
                      isSelected: selectedSemester == null,
                      onTap: () {
                        ref
                            .read(selectedSemesterNotifierProvider.notifier)
                            .clear();
                        Navigator.pop(context);
                      },
                    ),
                    ...semesters.map(
                      (semester) => _SemesterTile(
                        title: semester.name,
                        isSelected: selectedSemester?.id == semester.id,
                        onTap: () {
                          ref
                              .read(selectedSemesterNotifierProvider.notifier)
                              .setFromSemester(semester);
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
  }
}

// ── _SemesterTile — selectable semester row ───────────────────────────
class _SemesterTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SemesterTile({
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

// ── _CourseFilterButton — course filter dropdown ──────────────────────
class _CourseFilterButton extends StatelessWidget {
  final List<Course> courses;
  final String selectedCourseCode;
  final bool redBg;

  const _CourseFilterButton({
    required this.courses,
    required this.selectedCourseCode,
    this.redBg = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedCourse = courses.firstWhere(
      (c) => c.courseCode == selectedCourseCode,
      orElse: () => courses.first,
    );

    return GestureDetector(
      onTap: () => _showCourseSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
              selectedCourse.courseCode.toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: redBg ? Colors.white : theme.colorScheme.onSurface,
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
  }

  void _showCourseSheet(BuildContext context) {
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
            final filtered = searchText.isEmpty
                ? courses
                : courses
                      .where(
                        (c) =>
                            c.courseCode.toLowerCase().contains(
                              searchText.toLowerCase(),
                            ) ||
                            c.courseTitle.toLowerCase().contains(
                              searchText.toLowerCase(),
                            ),
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
                          'Select Course',
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
                          hintText: 'Search course...',
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
                  // Course list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final course = filtered[index];
                        final isSelected =
                            course.courseCode == selectedCourseCode;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            if (!isSelected) {
                              context.go(
                                Uri(
                                  path: '/study/courses/${course.courseCode}',
                                  queryParameters: {
                                    if (course.semesterName != null)
                                      'semester': course.semesterName!,
                                  },
                                ).toString(),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.courseCode.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected
                                              ? (isDark
                                                    ? Colors.red.shade300
                                                    : Colors.red.shade700)
                                              : (isDark
                                                    ? Colors.white54
                                                    : Colors.grey.shade600),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        course.courseTitle,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isSelected
                                              ? (isDark
                                                    ? Colors.red.shade300
                                                    : Colors.red.shade700)
                                              : (isDark
                                                    ? Colors.white
                                                    : Colors.black87),
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
                                    color: isDark
                                        ? Colors.red.shade300
                                        : Colors.red.shade700,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
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
