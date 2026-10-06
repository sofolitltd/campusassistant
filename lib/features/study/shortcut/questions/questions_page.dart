import 'dart:async';

import '/core/widgets/header_gradient_backdrop.dart';
import '/features/study/widgets/content_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../presentation/providers/questions_provider.dart';
import '/core/widgets/glass_search_bar.dart';
import '/features/study/widgets/batch_tile.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_font_size.dart';

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

  void _showYearFilterSheet(BuildContext context) {
    final years = ref.read(questionYearsProvider);
    final selectedYear = ref.read(questionsSelectedYearProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.colors.surfaceInverse.withValues(alpha: 0.5),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(RadiusToken.xxxl),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: Spacing.md),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.colors.borderStrong,
                      borderRadius: BorderRadius.circular(RadiusToken.md),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          'Select Year',
                          style: TextStyle(
                            fontSize: FontSizeToken.xl,
                            fontWeight: .bold,
                            color: context.colors.text,
                          ),
                        ),
                        if (selectedYear != null)
                          TextButton(
                            onPressed: () {
                              ref
                                      .read(
                                        questionsSelectedYearProvider.notifier,
                                      )
                                      .state =
                                  null;
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Clear Filter',
                              style: TextStyle(
                                fontWeight: .w600,
                                color: context.colors.danger,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.xl,
                        0,
                        Spacing.xl,
                        Spacing.xl,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: Spacing.sm,
                            crossAxisSpacing: Spacing.sm,
                            childAspectRatio: 4.2,
                          ),
                      itemCount: years.length + 1,
                      itemBuilder: (context, index) {
                        final isAll = index == 0;
                        final year = isAll ? null : years[index - 1];
                        return BatchTile(
                          grid: true,
                          title: isAll ? 'All Years' : year!,
                          isSelected: selectedYear == year,
                          onTap: () {
                            ref
                                    .read(
                                      questionsSelectedYearProvider.notifier,
                                    )
                                    .state =
                                year;
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

  void _showCourseFilterSheet(BuildContext context) {
    final selectedCourse = ref.read(questionsSelectedCourseProvider);
    final docs = ref.read(questionsPaginationProvider).asData?.value.docs ?? [];
    final courses =
        docs
            .map((d) => d.courseCode)
            .where((c) => c.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.colors.surfaceInverse.withValues(alpha: 0.5),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(RadiusToken.xxxl),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: Spacing.md),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.colors.borderStrong,
                      borderRadius: BorderRadius.circular(RadiusToken.md),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          'Select Course',
                          style: TextStyle(
                            fontSize: FontSizeToken.xl,
                            fontWeight: .bold,
                            color: context.colors.text,
                          ),
                        ),
                        if (selectedCourse != null)
                          TextButton(
                            onPressed: () {
                              ref
                                      .read(
                                        questionsSelectedCourseProvider
                                            .notifier,
                                      )
                                      .state =
                                  null;
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Clear Filter',
                              style: TextStyle(
                                fontWeight: .w600,
                                color: context.colors.danger,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xl,
                      ),
                      itemCount: courses.length + 1,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, index) {
                        final isAll = index == 0;
                        final course = isAll ? null : courses[index - 1];
                        final isSelected = selectedCourse == course;
                        final primary = Theme.of(context).appColors.primary;
                        final selectedColor = primary;
                        final selectedBg = context.colors.primarySubtle;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: selectedBg,
                          title: Text(
                            isAll ? 'All Courses' : course!,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? selectedColor
                                  : (context.colors.text),
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  LucideIcons.check,
                                  color: selectedColor,
                                  size: 20,
                                )
                              : null,
                          onTap: () {
                            ref
                                    .read(
                                      questionsSelectedCourseProvider.notifier,
                                    )
                                    .state =
                                course;
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
    final searchHint = 'Search questions...';

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: HeaderGradientBackdrop(
          extraHeight: 44, // filter row
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
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
              centerTitle: true,
            ),
            body: Column(
              children: [
                // ── Filter row ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: selectedCourse ?? 'Course',
                        isActive: selectedCourse != null,
                        onTap: () => _showCourseFilterSheet(context),
                      ),
                      const SizedBox(width: Spacing.md),
                      _buildFilterChip(
                        label: selectedYear ?? 'Year',
                        isActive: selectedYear != null,
                        onTap: () => _showYearFilterSheet(context),
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.lg,
                                        vertical: Spacing.sm,
                                      ),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'Showing ${state.docs.length} / ${state.totalCount}',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              fontWeight: .bold,
                                              color: context.colors.textMuted,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(
                                          Spacing.lg,
                                          0,
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
