import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusassistant/features/course/domain/entities/course.dart';
import 'package:campusassistant/features/course/presentation/providers/course_provider.dart';
import 'package:campusassistant/features/batch/presentation/providers/selected_batch_provider.dart';
import 'package:campusassistant/features/batch/presentation/providers/batch_list_provider.dart';
import 'package:campusassistant/features/study/semester/presentation/providers/semester_provider.dart';
import 'package:campusassistant/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/widgets/breadcrumbs.dart';
import '/core/theme/tokens/app_spacing.dart';
import 'course_card.dart';

// ---------------------------------------------------------------------------
// CoursesPage
//
// Displays courses filtered by batch + semester.
//
// ARCHITECTURE:
//   - Batch and semester selections live in global Riverpod notifiers.
//   - URL query params (batch, semesterName, semesterId) are read ONCE in
//     initState via a post-frame callback with a _initialized guard.
//   - After that single init, all changes come from the dropdowns on this page.
//   - No auto-reset of semester when batch changes — user controls both.
// ---------------------------------------------------------------------------
class CoursesPage extends ConsumerStatefulWidget {
  final String? batch;
  final String? semesterName;
  final String? semesterId;

  const CoursesPage({
    super.key,
    this.batch,
    this.semesterName,
    this.semesterId,
  });

  @override
  ConsumerState<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  // Guard: URL params are synced exactly once per page instantiation.
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Use a single post-frame callback to sync URL params into global state.
    // This runs only once because of the _initialized guard.
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncFromUrl());
  }

  void _syncFromUrl() {
    if (_initialized || !mounted) return;
    _initialized = true;

    final batchNotifier = ref.read(selectedBatchNotifierProvider.notifier);
    final semesterNotifier = ref.read(
      selectedSemesterNotifierProvider.notifier,
    );

    // --- Sync Batch from URL ---
    if (widget.batch != null && widget.batch!.isNotEmpty) {
      if (widget.batch == 'all' || widget.batch == 'all_batches') {
        batchNotifier.setAll();
      } else {
        // batches are almost always loaded since we arrive from semester_page
        // which already has them. Read and match directly.
        final batches = ref.read(batchProviderStudy).value ?? [];
        final match = batches
            .where(
              (b) =>
                  b.id == widget.batch ||
                  b.slug == widget.batch ||
                  b.name == widget.batch,
            )
            .firstOrNull;
        if (match != null) {
          batchNotifier.setSelectedBatch(match);
        }
      }
    }

    // --- Sync Semester from URL ---
    if (widget.semesterId != null && widget.semesterId!.isNotEmpty) {
      final name = widget.semesterName ?? widget.semesterId!;
      semesterNotifier.setSemester(widget.semesterId!, name);
    } else if (widget.semesterName != null && widget.semesterName!.isNotEmpty) {
      // Only name provided — resolve ID from loaded semesters
      final semesters = ref.read(semestersProvider).value;
      if (semesters != null) {
        final match = semesters
            .where((s) => s.name == widget.semesterName)
            .firstOrNull;
        if (match != null) semesterNotifier.setFromSemester(match);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedBatch = ref.watch(resolvedBatchProvider);
    final selectedSemester = ref.watch(selectedSemesterNotifierProvider);

    final batchNotifier = ref.read(selectedBatchNotifierProvider.notifier);
    final semesterNotifier = ref.read(
      selectedSemesterNotifierProvider.notifier,
    );

    final userAsync = ref.watch(userProvider);
    final batchesAsync = ref.watch(batchProviderStudy);
    final semestersProviderState = ref.watch(semestersProvider);
    final filteredSemesters = ref.watch(filteredSemestersProvider);

    final currentSemesterName = selectedSemester?.name ?? '';
    final currentSemesterId = selectedSemester?.id;

    return userAsync.when(
      data: (user) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              currentSemesterName.isNotEmpty
                  ? 'Courses ($currentSemesterName)'
                  : 'Courses',
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Breadcrumbs(),

              // ── Filter row ──────────────────────────────────────────────
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    const Text('Filter:'),
                    const Spacer(),

                    // ── Semester Dropdown ────────────────────────────────
                    if (semestersProviderState.isLoading)
                      const SizedBox(
                        width: 110,
                        height: 32,
                        child: Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    else
                      _BatchOrSemesterDropdown(
                        key: ValueKey('sem-${selectedBatch?.id ?? 'all'}-${selectedSemester?.id ?? 'null'}'),
                        width: 110,
                        initialSelection: selectedSemester?.id,
                        hintText: 'All',
                        entries: [
                          const DropdownMenuEntry(value: null, label: 'All'),
                          ...filteredSemesters.map(
                            (s) =>
                                DropdownMenuEntry(value: s.id, label: s.name),
                          ),
                        ],
                        onSelected: (id) {
                          if (id == null) {
                            semesterNotifier.clear();
                          } else {
                            final sem = filteredSemesters
                                .where((s) => s.id == id)
                                .firstOrNull;
                            if (sem != null) {
                              semesterNotifier.setFromSemester(sem);
                            }
                          }
                        },
                      ),

                    const SizedBox(width: 12),

                    // ── Batch Dropdown ───────────────────────────────────
                    batchesAsync.when(
                      data: (batches) => _BatchOrSemesterDropdown(
                        key: ValueKey('batch-${selectedBatch?.id ?? 'null'}'),
                        width: 110,
                        initialSelection: selectedBatch?.id,
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
                          if (id == 'all_batches' || id == null) {
                            batchNotifier.setAll();
                          } else {
                            final match = batches
                                .where((b) => b.id == id)
                                .firstOrNull;
                            if (match != null) {
                              batchNotifier.setSelectedBatch(match);
                              // Clear semester when batch changes so user picks
                              // a semester valid for the new batch.
                              semesterNotifier.clear();
                            }
                          }
                        },
                      ),
                      loading: () => const SizedBox(width: 110, height: 32),
                      error: (e, _) => const Text("Failed"),
                    ),
                  ],
                ),
              ),

              // ── Course List ──────────────────────────────────────────────
              Expanded(
                child: (() {
                  final uid = user.information.universityId;
                  final did = user.information.departmentId;
                  if (uid == null || uid.isEmpty || did == null || did.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.userX, size: 48, color: Colors.grey),
                          const SizedBox(height: Spacing.lg),
                          const Text('User profile incomplete'),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => ref.invalidate(userProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return ref
                      .watch(
                        coursesProvider(
                          universityId: uid,
                          departmentId: did,
                          courseYear: currentSemesterId,
                          batchId: isAllBatches(selectedBatch)
                              ? null
                              : selectedBatch?.id,
                        ),
                      )
                      .when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                                const SizedBox(height: Spacing.lg),
                                Text('Error: $e', textAlign: TextAlign.center),
                                const SizedBox(height: Spacing.lg),
                                ElevatedButton.icon(
                                  onPressed: () => ref.invalidate(coursesProvider(
                                    universityId: uid,
                                    departmentId: did,
                                    courseYear: currentSemesterId,
                                    batchId: isAllBatches(selectedBatch)
                                        ? null
                                        : selectedBatch?.id,
                                  )),
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        data: (coursesList) {
                          Future<void> refresh() async {
                            ref.invalidate(coursesProvider(
                              universityId: uid,
                              departmentId: did,
                              courseYear: currentSemesterId,
                              batchId: isAllBatches(selectedBatch)
                                  ? null
                                  : selectedBatch?.id,
                            ));
                            await ref.read(coursesProvider(
                              universityId: uid,
                              departmentId: did,
                              courseYear: currentSemesterId,
                              batchId: isAllBatches(selectedBatch)
                                  ? null
                                  : selectedBatch?.id,
                            ).future);
                          }

                          if (coursesList.isEmpty) {
                            return RefreshIndicator(
                              onRefresh: refresh,
                              child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(LucideIcons.bookOpen, size: 48, color: Colors.grey),
                                          const SizedBox(height: Spacing.lg),
                                          const Text('No courses available'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final Map<String, List<Course>> coursesByCategory = {};
                          for (final course in coursesList) {
                            final category = course.courseCategory?.name ??
                                course.courseCategoryId ?? 'Unknown';
                            coursesByCategory.putIfAbsent(category, () => []).add(course);
                          }

                          final categories = coursesByCategory.keys.toList()..sort();

                          return RefreshIndicator(
                            onRefresh: refresh,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                              children: categories.map(
                                (cat) => CourseCard(
                                  courseCategory: cat,
                                  courses: coursesByCategory[cat]!,
                                  selectedBatch: isAllBatches(selectedBatch)
                                      ? ''
                                      : (selectedBatch?.slug ??
                                            selectedBatch?.id ??
                                            ''),
                                  selectedSemester: currentSemesterName,
                                ),
                              ).toList(),
                            ),
                          );
                        },
                      );
                }()),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: Spacing.lg),
              Text('Error: $e', textAlign: TextAlign.center),
              const SizedBox(height: Spacing.lg),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(userProvider),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _BatchOrSemesterDropdown
//
// A keyed wrapper around DropdownMenu so Flutter fully rebuilds it (and
// resets initialSelection) whenever the external state changes.
// This fixes the Flutter bug where DropdownMenu ignores initialSelection
// after the first build.
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
            padding: WidgetStateProperty.all(EdgeInsets.zero),
          ),
        ),
      ],
    );
  }
}
