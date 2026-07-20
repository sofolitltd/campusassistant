import 'dart:async';

import '/features/study/widgets/content_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../presentation/providers/questions_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';

class QuestionsPage extends ConsumerStatefulWidget {
  const QuestionsPage({super.key});

  @override
  ConsumerState<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends ConsumerState<QuestionsPage> {
  final ScrollController _scrollController = ScrollController();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final years = ref.read(questionYearsProvider);
    final selectedYear = ref.read(questionsSelectedYearProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Year',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.grey.shade900,
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
                            child: const Text(
                              'Clear Filter',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: years.length + 1,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, index) {
                        final isAll = index == 0;
                        final year = isAll ? null : years[index - 1];
                        final isSelected = selectedYear == year;
                        final primary = Theme.of(
                          context,
                        ).appColors.primaryColor;
                        final selectedColor = primary;
                        final selectedBg = primary.withValues(
                          alpha: isDark ? 0.22 : 0.12,
                        );

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: selectedBg,
                          title: Text(
                            isAll ? 'All Years' : year!,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? selectedColor
                                  : (isDark ? Colors.white : Colors.black87),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
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
                            color: isDark ? Colors.white : Colors.grey.shade900,
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
                            child: const Text(
                              'Clear Filter',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: courses.length + 1,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, index) {
                        final isAll = index == 0;
                        final course = isAll ? null : courses[index - 1];
                        final isSelected = selectedCourse == course;
                        final primary = Theme.of(
                          context,
                        ).appColors.primaryColor;
                        final selectedColor = primary;
                        final selectedBg = primary.withValues(
                          alpha: isDark ? 0.22 : 0.12,
                        );

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
                                  : (isDark ? Colors.white : Colors.black87),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Theme.of(context).appColors.primaryColor;

    final questionsAsync = ref.watch(questionsPaginationProvider);
    final selectedCourse = ref.watch(questionsSelectedCourseProvider);
    final selectedYear = ref.watch(questionsSelectedYearProvider);
    final searchHint = 'Search questions...';

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Question Bank',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Search bar ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // ── Filter row ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                _buildFilterChip(
                  label: selectedCourse ?? 'Course',
                  isActive: selectedCourse != null,
                  onTap: () => _showCourseFilterSheet(context),
                ),
                const SizedBox(width: 12),
                _buildFilterChip(
                  label: selectedYear ?? 'Year',
                  isActive: selectedYear != null,
                  onTap: () => _showYearFilterSheet(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── White body area ───────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: questionsAsync.when(
                  data: (state) {
                    if (state.docs.isEmpty && !state.isLoadingMore) {
                      return const Center(
                        child: Text('No questions found for your department.'),
                      );
                    }

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Showing ${state.docs.length} / ${state.totalCount}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            controller: _scrollController,
                            itemCount:
                                state.docs.length + (state.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.docs.length - 5 &&
                                  state.hasMore &&
                                  !state.isLoadingMore) {
                                Future.microtask(() {
                                  ref
                                      .read(
                                        questionsPaginationProvider.notifier,
                                      )
                                      .loadNextPage();
                                });
                              }

                              if (index < state.docs.length) {
                                final doc = state.docs[index];
                                return ContentCard(contentModel: doc);
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CupertinoActivityIndicator(),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Loading more questions...',
                                          style: TextStyle(fontSize: 12),
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
                  loading: () =>
                      const Center(child: CupertinoActivityIndicator()),
                  error: (e, st) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.circleAlert,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: Spacing.lg),
                        Text('Error: $e'),
                        TextButton(
                          onPressed: () => ref
                              .read(questionsPaginationProvider.notifier)
                              .refresh(),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
