import 'dart:async';

import '/core/widgets/header_gradient_backdrop.dart';
import '/features/study/widgets/content_card.dart';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../presentation/providers/questions_provider.dart';
import '/core/widgets/glass_search_bar.dart';
import '/core/widgets/inline_search_bar.dart';
import '/features/study/widgets/batch_tile.dart';
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

  void _showYearFilterSheet(BuildContext context) {
    _showPickerSheet(
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

  void _showCourseFilterSheet(BuildContext context) {
    final docs = ref.read(questionsPaginationProvider).asData?.value.docs ?? [];
    final courses =
        docs
            .map((d) => d.courseCode.trim().toUpperCase())
            .where((c) => c.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    final selected = ref.read(questionsSelectedCourseProvider);

    _showPickerSheet(
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
            : docs
                  .map((d) => d.courseCode.trim())
                  .firstWhere(
                    (c) => c.toUpperCase() == code,
                    orElse: () => code,
                  );
        ref.read(questionsSelectedCourseProvider.notifier).state = raw;
      },
    );
  }

  /// Same layout as the study page's batch picker ([BatchDropdown]): title +
  /// close, search bar, then a two-column grid with an "All" tile first.
  void _showPickerSheet(
    BuildContext context, {
    required String title,
    required String searchHint,
    required String allLabel,
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
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
            final q = searchText.trim().toLowerCase();
            final filtered = q.isEmpty
                ? options
                : options.where((o) => o.toLowerCase().contains(q)).toList();

            void pick(String? value) {
              onSelected(value);
              Navigator.pop(context);
            }

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
                          title,
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
                      hintText: searchHint,
                      onChanged: (v) => setState(() => searchText = v),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Expanded(
                    child: filtered.isEmpty && q.isNotEmpty
                        ? Center(
                            child: Text(
                              'No matches',
                              style: TextStyle(color: context.colors.textMuted),
                            ),
                          )
                        : GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: Spacing.sm,
                            crossAxisSpacing: Spacing.sm,
                            childAspectRatio: 4.2,
                            padding: const EdgeInsets.fromLTRB(
                              Spacing.xl,
                              0,
                              Spacing.xl,
                              Spacing.xl,
                            ),
                            children: [
                              if (q.isEmpty)
                                BatchTile(
                                  grid: true,
                                  title: allLabel,
                                  isSelected: selected == null,
                                  onTap: () => pick(null),
                                ),
                              ...filtered.map(
                                (o) => BatchTile(
                                  grid: true,
                                  title: o,
                                  isSelected: selected == o,
                                  onTap: () => pick(o),
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
