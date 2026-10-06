import 'package:flutter/cupertino.dart';
import '/features/bookmark/presentation/widgets/bookmark_app_bar_button.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/ads/banner_ad_widget.dart';
import '/features/course/domain/entities/course.dart';
import '/features/course/presentation/providers/course_provider.dart';
import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '../../../study/levels/presentation/providers/semester_provider.dart';
import '../../../study/levels/domain/entities/semester.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/inline_search_bar.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import 'course_card.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_font_size.dart';

// ---------------------------------------------------------------------------
// CoursesPage
//
// Displays courses filtered by batch + semester.
//
// ARCHITECTURE:
//   - Batch and semester selections live in global Riverpod notifiers.
//   - URL query params (batch, semesterName, semesterId) are read ONCE in
//     initState via a post-frame callback with a _initialized guard.
//   - After that single init, all changes come from the filter buttons on
//     this page.
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
        final batches = ref.read(batchProviderAll).value ?? [];
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
    final theme = Theme.of(context);
    final selectedBatch = ref.watch(resolvedBatchProvider);
    final selectedSemester = ref.watch(selectedSemesterNotifierProvider);

    final userAsync = ref.watch(userProvider);
    final batchesAsync = ref.watch(batchProviderStudy);
    final semestersProviderState = ref.watch(semestersProvider);
    final filteredSemesters = ref.watch(filteredSemestersProvider);

    final currentSemesterName = selectedSemester?.name ?? '';
    final currentSemesterId = selectedSemester?.id;

    return userAsync.when(
      data: (user) {
        return HeaderGradientBackdrop(
          extraHeight: 44, // filter row
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              iconTheme: IconThemeData(color: context.colors.onPrimary),
              centerTitle: false,
              titleSpacing: 0,
              actions: [const BookmarkAppBarButton()],
              title: Text(
                currentSemesterName.isNotEmpty
                    ? 'Courses ($currentSemesterName)'
                    : 'Courses',
                style: TextStyle(
                  color: context.colors.onPrimary,
                  fontWeight: .bold,
                  fontSize: FontSizeToken.xl,
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: .start,
              children: [
                // ── Filter row (red area) ───────────────────────────────
                Padding(
                  padding: const .fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      // Batch filter (first)
                      batchesAsync.when(
                        data: (batches) {
                          if (batches.isEmpty) return const SizedBox();
                          return _BatchButton(
                            batches: batches,
                            selectedBatch: selectedBatch,
                          );
                        },
                        loading: () => SizedBox(
                          width: 100,
                          height: 32,
                          child: Center(
                            child: CupertinoActivityIndicator(
                              color: context.colors.onPrimary,
                            ),
                          ),
                        ),
                        error: (_, _) => SizedBox(
                          width: 100,
                          height: 32,
                          child: Center(
                            child: Text(
                              'Failed',
                              style: TextStyle(
                                color: context.colors.textSubtle,
                                fontSize: FontSizeToken.sm,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      // Semester/Year filter (second)
                      if (semestersProviderState.isLoading)
                        SizedBox(
                          width: 100,
                          height: 32,
                          child: Center(
                            child: CupertinoActivityIndicator(
                              color: context.colors.onPrimary,
                            ),
                          ),
                        )
                      else
                        _SemesterButton(
                          semesters: filteredSemesters,
                          selectedSemester: selectedSemester,
                        ),
                    ],
                  ),
                ),

                // ── White rounded container ─────────────────────────────
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(RadiusToken.xxxl),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(RadiusToken.xxxl),
                      ),
                      child: (() {
                        final uid = user.information.universityId;
                        final did = user.information.departmentId;
                        if (uid == null ||
                            uid.isEmpty ||
                            did == null ||
                            did.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: .center,
                              children: [
                                Icon(
                                  LucideIcons.userX,
                                  size: 48,
                                  color: context.colors.textSubtle,
                                ),
                                const SizedBox(height: Spacing.lg),
                                const Text('User profile incomplete'),
                                const SizedBox(height: Spacing.sm),
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
                                semesterId: currentSemesterId,
                                batchId: isAllBatches(selectedBatch)
                                    ? null
                                    : selectedBatch?.id,
                              ),
                            )
                            .when(
                              loading: () => const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              error: (e, _) => Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(Spacing.xxl),
                                  child: Column(
                                    mainAxisAlignment: .center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: context.colors.danger,
                                      ),
                                      const SizedBox(height: Spacing.lg),
                                      Text('Error: $e', textAlign: .center),
                                      const SizedBox(height: Spacing.lg),
                                      ElevatedButton.icon(
                                        onPressed: () => ref.invalidate(
                                          coursesProvider(
                                            universityId: uid,
                                            departmentId: did,
                                            semesterId: currentSemesterId,
                                            batchId: isAllBatches(selectedBatch)
                                                ? null
                                                : selectedBatch?.id,
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.refresh,
                                          size: 18,
                                        ),
                                        label: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              data: (coursesList) {
                                Future<void> refresh() async {
                                  ref.invalidate(
                                    coursesProvider(
                                      universityId: uid,
                                      departmentId: did,
                                      semesterId: currentSemesterId,
                                      batchId: isAllBatches(selectedBatch)
                                          ? null
                                          : selectedBatch?.id,
                                    ),
                                  );
                                  await ref.read(
                                    coursesProvider(
                                      universityId: uid,
                                      departmentId: did,
                                      semesterId: currentSemesterId,
                                      batchId: isAllBatches(selectedBatch)
                                          ? null
                                          : selectedBatch?.id,
                                    ).future,
                                  );
                                }

                                if (coursesList.isEmpty) {
                                  return RefreshIndicator(
                                    onRefresh: refresh,
                                    child: ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  LucideIcons.bookOpen,
                                                  size: 48,
                                                  color:
                                                      context.colors.textSubtle,
                                                ),
                                                const SizedBox(
                                                  height: Spacing.lg,
                                                ),
                                                const Text(
                                                  'No courses available',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final Map<String, List<Course>>
                                coursesByCategory = {};
                                for (final course in coursesList) {
                                  final category =
                                      course.courseCategory?.name ??
                                      course.courseCategoryId ??
                                      'Unknown';
                                  coursesByCategory
                                      .putIfAbsent(category, () => [])
                                      .add(course);
                                }

                                final categories =
                                    coursesByCategory.keys.toList()..sort();

                                return RefreshIndicator(
                                  onRefresh: refresh,
                                  child: ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(
                                      Spacing.sm,
                                      Spacing.sm,
                                      Spacing.sm,
                                      Spacing.lg,
                                    ),
                                    children: [
                                      ...categories.map(
                                        (cat) => CourseCard(
                                          courseCategory: cat,
                                          courses: coursesByCategory[cat]!,
                                          selectedBatch:
                                              isAllBatches(selectedBatch)
                                              ? ''
                                              : (selectedBatch?.slug ??
                                                    selectedBatch?.id ??
                                                    ''),
                                          selectedSemester: currentSemesterName,
                                        ),
                                      ),
                                      const BannerAdWidget(),
                                    ],
                                  ),
                                );
                              },
                            );
                      }()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CupertinoActivityIndicator())),
      error: (e, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(Icons.error_outline, size: 48, color: context.colors.danger),
              const SizedBox(height: Spacing.lg),
              Text('Error: $e', textAlign: .center),
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

// ── _SemesterButton ─────────────────────────────────────────────────────
class _SemesterButton extends ConsumerWidget {
  final List<Semester> semesters;
  final SelectedSemester? selectedSemester;

  const _SemesterButton({
    required this.semesters,
    required this.selectedSemester,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showSemesterSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface.withValues(alpha: 0.15),
          border: Border.all(
            color: context.colors.onPrimary.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.graduationCap,
              size: 14,
              color: context.colors.onPrimary,
            ),
            const SizedBox(width: Spacing.sm),
            Text(
              selectedSemester?.name ?? 'All',
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: .w500,
                color: context.colors.onPrimary,
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: context.colors.onPrimary,
            ),
          ],
        ),
      ),
    );
  }

  void _showSemesterSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(selectedSemesterNotifierProvider.notifier);
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = searchText.isEmpty
                ? semesters
                : semesters
                      .where(
                        (s) => s.name.toLowerCase().contains(
                          searchText.toLowerCase(),
                        ),
                      )
                      .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.only(top: Spacing.md),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.colors.borderStrong,
                        borderRadius: BorderRadius.circular(RadiusToken.xs),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          'Select Level',
                          style: TextStyle(
                            fontSize: FontSizeToken.xl,
                            fontWeight: .bold,
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
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: InlineSearchBar(
                      hintText: 'Search level...',
                      onChanged: (v) => setState(() => searchText = v),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                      ),
                      children: [
                        if (searchText.isEmpty)
                          _FilterTile(
                            title: 'All',
                            isSelected: selectedSemester == null,
                            onTap: () {
                              notifier.clear();
                              Navigator.pop(context);
                            },
                          ),
                        ...filtered.map(
                          (s) => _FilterTile(
                            title: s.name,
                            isSelected: selectedSemester?.id == s.id,
                            onTap: () {
                              notifier.setFromSemester(s);
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

// ── _BatchButton ────────────────────────────────────────────────────────
class _BatchButton extends ConsumerWidget {
  final List<Batch> batches;
  final Batch? selectedBatch;

  const _BatchButton({required this.batches, required this.selectedBatch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showBatchSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface.withValues(alpha: 0.15),
          border: Border.all(
            color: context.colors.onPrimary.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(LucideIcons.users, size: 14, color: context.colors.onPrimary),
            const SizedBox(width: Spacing.sm),
            Text(
              selectedBatch?.name ?? 'All Batches',
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: .w500,
                color: context.colors.onPrimary,
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: context.colors.onPrimary,
            ),
          ],
        ),
      ),
    );
  }

  void _showBatchSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
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
              padding: const EdgeInsets.only(top: Spacing.md),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.colors.borderStrong,
                        borderRadius: BorderRadius.circular(RadiusToken.xs),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          'Select Batch',
                          style: TextStyle(
                            fontSize: FontSizeToken.xl,
                            fontWeight: .bold,
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
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: InlineSearchBar(
                      hintText: 'Search batch...',
                      onChanged: (v) => setState(() => searchText = v),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                      ),
                      children: [
                        if (searchText.isEmpty)
                          _FilterTile(
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
                          (b) => _FilterTile(
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

// ── _FilterTile ─────────────────────────────────────────────────────────
class _FilterTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final selectedBg = context.colors.primarySubtle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: Spacing.xxs,
          horizontal: Spacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: FontSizeToken.lg,
                color: isSelected ? primary : (context.colors.text),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected) Icon(LucideIcons.check, color: primary, size: 20),
          ],
        ),
      ),
    );
  }
}
