import 'dart:async';

import '/core/widgets/header_gradient_backdrop.dart';
import '/features/study/widgets/content_card.dart';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../presentation/providers/questions_provider.dart';
import '/features/study/levels/domain/entities/semester.dart';
import '/features/study/levels/presentation/providers/semester_provider.dart';
import '/core/widgets/glass_search_bar.dart';
import '/features/study/widgets/filter_picker_sheet.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_layout.dart';

class QuestionsPage extends ConsumerStatefulWidget {
  const QuestionsPage({super.key});

  @override
  ConsumerState<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends ConsumerState<QuestionsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(questionsScopeUniversityProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      ref.read(questionsSearchQueryProvider.notifier).state = val;
    });
  }

  void _clearFilters() {
    ref.read(questionsSelectedLevelProvider.notifier).state = null;
    ref.read(questionsSelectedCourseProvider.notifier).state = null;
    ref.read(questionsSelectedYearProvider.notifier).state = null;
  }

  void _showYearFilterSheet(BuildContext context) {
    showFilterPickerSheet(
      context,
      title: 'Select Year',
      searchHint: 'Search year...',
      allLabel: 'All Years',
      options: ref.read(questionYearsProvider),
      selected: ref.read(questionsSelectedYearProvider),
      onSelected: (year) =>
          ref.read(questionsSelectedYearProvider.notifier).state = year,
    );
  }

  Future<void> _showLevelFilterSheet(BuildContext context) async {
    final levels = [
      ...await ref
          .read(semestersProvider.future)
          .catchError((_) => <Semester>[]),
    ]..sort((a, b) => a.order.compareTo(b.order));
    if (!context.mounted) return;
    final selectedId = ref.read(questionsSelectedLevelProvider);

    showFilterPickerSheet(
      context,
      title: 'Select Level',
      searchHint: 'Search level...',
      allLabel: 'All Levels',
      options: levels.map((l) => l.name).toList(),
      selected: levels.where((l) => l.id == selectedId).firstOrNull?.name,
      onSelected: (name) async {
        final levelId = levels.where((l) => l.name == name).firstOrNull?.id;
        ref.read(questionsSelectedLevelProvider.notifier).state = levelId;
        // Drop a course that isn't in the new level.
        final course = ref.read(questionsSelectedCourseProvider);
        if (levelId == null || course == null) return;
        final courses = await ref
            .read(questionCourseCodesProvider.future)
            .catchError((_) => <({String code, String levelId})>[]);
        final inLevel = courses.any(
          (c) => c.levelId == levelId && c.code == course,
        );
        if (!inLevel) {
          ref.read(questionsSelectedCourseProvider.notifier).state = null;
        }
      },
    );
  }

  Future<void> _showCourseFilterSheet(BuildContext context) async {
    final docs = ref.read(questionsPaginationProvider).asData?.value.docs ?? [];
    final levelId = ref.read(questionsSelectedLevelProvider);
    // The department's courses (only the selected level's, if any), plus any
    // on loaded questions (university scope can show other departments').
    final deptCourses = await ref
        .read(questionCourseCodesProvider.future)
        .catchError((_) => <({String code, String levelId})>[]);
    if (!context.mounted) return;
    final rawCodes = [
      ...deptCourses
          .where((c) => levelId == null || c.levelId == levelId)
          .map((c) => c.code),
      ...docs.map((d) => d.courseCode.trim()),
    ];
    final courses =
        rawCodes
            .map((c) => c.toUpperCase())
            .where((c) => c.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    final selected = ref.read(questionsSelectedCourseProvider);

    showFilterPickerSheet(
      context,
      title: 'Select Course',
      searchHint: 'Search course...',
      allLabel: 'All Courses',
      options: courses,
      selected: selected?.toUpperCase(),
      // Pass back the code exactly as the data has it, so filtering by
      // course still matches whatever casing the backend stores.
      onSelected: (code) {
        final raw = code == null
            ? null
            : rawCodes.firstWhere(
                (c) => c.toUpperCase() == code,
                orElse: () => code,
              );
        ref.read(questionsSelectedCourseProvider.notifier).state = raw;
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
            Text(
              label,
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final questionsAsync = ref.watch(questionsPaginationProvider);
    final selectedCourse = ref.watch(questionsSelectedCourseProvider);
    final selectedYear = ref.watch(questionsSelectedYearProvider);
    final selectedLevelId = ref.watch(questionsSelectedLevelProvider);
    final selectedLevelName = selectedLevelId == null
        ? null
        : (ref.watch(semestersProvider).value ?? [])
              .where((l) => l.id == selectedLevelId)
              .firstOrNull
              ?.name;
    final searchHint = 'Search questions...';

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: AppLayout.pageWidth),
        child: HeaderGradientBackdrop(
          extraHeight: 44, // filter row
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              scrolledUnderElevation: 0,
              iconTheme: IconThemeData(color: context.colors.onPrimary),
              title: Text(
                'Question Bank',
                style: TextStyle(
                  color: context.colors.onPrimary,
                  fontWeight: .bold,
                  fontSize: FontSizeToken.xl,
                ),
              ),
              centerTitle: false,
            ),
            body: Column(
              children: [
                // ── Filter row ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: selectedLevelName ?? 'Level',
                        isActive: selectedLevelName != null,
                        onTap: () => _showLevelFilterSheet(context),
                      ),
                      const SizedBox(width: Spacing.md),
                      _buildFilterChip(
                        label: selectedCourse?.toUpperCase() ?? 'Course',
                        isActive: selectedCourse != null,
                        onTap: () => _showCourseFilterSheet(context),
                      ),
                      const SizedBox(width: Spacing.md),
                      _buildFilterChip(
                        label: selectedYear ?? 'Year',
                        isActive: selectedYear != null,
                        onTap: () => _showYearFilterSheet(context),
                      ),
                      const Spacer(),
                      if (selectedLevelId != null ||
                          selectedCourse != null ||
                          selectedYear != null)
                        GestureDetector(
                          onTap: _clearFilters,
                          behavior: HitTestBehavior.opaque,
                          child: Semantics(
                            button: true,
                            label: 'Clear filters',
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: Spacing.sm,
                                top: Spacing.xs,
                                bottom: Spacing.xs,
                              ),
                              child: Icon(
                                LucideIcons.x,
                                size: 18,
                                color: context.colors.onPrimary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ── White body area ───────────────────────────────────────
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
                      child: Column(
                        children: [
                          GlassSearchBar(
                            atTop: true,
                            controller: _searchController,
                            hint: searchHint,
                            onChanged: _onSearchChanged,
                            onClear: () => _onSearchChanged(''),
                          ),
                          Expanded(
                            child: questionsAsync.when(
                              data: (state) {
                                if (state.docs.isEmpty &&
                                    !state.isLoadingMore) {
                                  return const Center(
                                    child: Text(
                                      'No questions found for your department.',
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(
                                          Spacing.lg,
                                          Spacing.sm,
                                          Spacing.lg,
                                          Spacing.lg,
                                        ),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: Spacing.md),
                                        controller: _scrollController,
                                        itemCount:
                                            state.docs.length +
                                            (state.hasMore ? 1 : 0),
                                        itemBuilder: (context, index) {
                                          if (index >= state.docs.length - 5 &&
                                              state.hasMore &&
                                              !state.isLoadingMore) {
                                            Future.microtask(() {
                                              ref
                                                  .read(
                                                    questionsPaginationProvider
                                                        .notifier,
                                                  )
                                                  .loadNextPage();
                                            });
                                          }

                                          if (index < state.docs.length) {
                                            final doc = state.docs[index];
                                            return ContentCard(
                                              contentModel: doc,
                                            );
                                          } else {
                                            return const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: Spacing.lg,
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 14,
                                                      height: 14,
                                                      child:
                                                          CupertinoActivityIndicator(),
                                                    ),
                                                    SizedBox(width: Spacing.sm),
                                                    Text(
                                                      'Loading more questions...',
                                                      style: TextStyle(
                                                        fontSize:
                                                            FontSizeToken.sm,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                              loading: () => const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              error: (e, st) => Center(
                                child: Column(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Icon(
                                      LucideIcons.circleAlert,
                                      color: context.colors.danger,
                                      size: 48,
                                    ),
                                    const SizedBox(height: Spacing.lg),
                                    Text('Error: $e'),
                                    TextButton(
                                      onPressed: () => ref
                                          .read(
                                            questionsPaginationProvider
                                                .notifier,
                                          )
                                          .refresh(),
                                      child: const Text('Try Again'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
