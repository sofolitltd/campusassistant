import 'package:campusassistant/widgets/breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:campusassistant/features/course/presentation/providers/course_provider.dart';
import 'package:campusassistant/features/course/presentation/providers/course_state_provider.dart';
import 'package:campusassistant/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:campusassistant/features/batch/presentation/providers/selected_batch_provider.dart';
import 'package:campusassistant/features/batch/presentation/providers/batch_list_provider.dart';
import 'package:campusassistant/features/study/semester/presentation/providers/semester_provider.dart';
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

            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                centerTitle: true,
                title: Text(
                  '$safeCourseCode : $safeCourseTitle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // AppBar bottom = TabBar ONLY
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: kCourseType.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Breadcrumbs ───────────────────────────────────────
                  const Breadcrumbs(),

                  // ── Filter row (identical to CoursesPage) ────────────
                  Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: [
                        const Text('Filter:'),
                        const Spacer(),
                        batchesAsync.when(
                          data: (batches) {
                            if (batches.isEmpty) return const SizedBox();
                            return _BatchOrSemesterDropdown(
                              key: ValueKey(
                                'cf-batch-${selectedBatch?.id ?? 'null'}',
                              ),
                              width: 110,
                              initialSelection: isAllBatches(selectedBatch)
                                  ? 'all_batches'
                                  : selectedBatch?.id,
                              hintText: 'All Batches',
                              entries: [
                                const DropdownMenuEntry(
                                  value: 'all_batches',
                                  label: 'All Batches',
                                ),
                                ...batches.map(
                                  (b) => DropdownMenuEntry<String?>(
                                    value: b.id,
                                    label: b.name,
                                  ),
                                ),
                              ],
                              onSelected: (id) {
                                final notifier = ref.read(
                                  selectedBatchNotifierProvider.notifier,
                                );
                                if (id == null || id == 'all_batches') {
                                  notifier.setAll();
                                } else {
                                  final match = batches
                                      .where((b) => b.id == id)
                                      .firstOrNull;
                                  if (match != null) {
                                    notifier.setSelectedBatch(match);
                                  }
                                }
                              },
                            );
                          },
                          loading: () => const SizedBox(width: 110, height: 32),
                          error: (_, _) => const SizedBox(),
                        ),
                      ],
                    ),
                  ),

                  // ── Tab content ───────────────────────────────────────
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
                  ), // Expanded
                ],
              ), // Column (body)
            ); // Scaffold
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

// ---------------------------------------------------------------------------
// _BatchOrSemesterDropdown — keyed compact dropdown, identical to CoursesPage
// ---------------------------------------------------------------------------
class _BatchOrSemesterDropdown extends StatelessWidget {
  final double width;
  final String? initialSelection;
  final String hintText;
  final List<DropdownMenuEntry<String?>> entries;
  final void Function(String? id) onSelected;

  const _BatchOrSemesterDropdown({
    super.key,
    required this.width,
    required this.initialSelection,
    required this.hintText,
    required this.entries,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: true,
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 16),
          ),
        ),
        DropdownMenu<String?>(
          width: width,
          initialSelection: initialSelection,
          hintText: hintText,
          textStyle: const TextStyle(fontSize: 14),
          requestFocusOnTap: false,
          showTrailingIcon: false,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.only(left: 6, top: 4, bottom: 6),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            constraints: const BoxConstraints(maxHeight: 32),
            isDense: true,
            isCollapsed: true,
          ),
          alignmentOffset: const Offset(0, 8),
          onSelected: onSelected,
          dropdownMenuEntries: entries,

          menuStyle: MenuStyle(
            fixedSize: WidgetStateProperty.all(Size.fromWidth(width)),
            backgroundColor: WidgetStateProperty.all(Theme.of(context).cardColor),
            visualDensity: VisualDensity.compact,
            padding: WidgetStateProperty.all(.zero),
          ),
        ),
      ],
    );
  }
}
