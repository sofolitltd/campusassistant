import 'package:campusassistant/features/study/widgets/content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../presentation/providers/questions_provider.dart';
import '/core/widgets/red_header_layout.dart';
import '/core/theme/tokens/app_spacing.dart';

class QuestionsPage extends ConsumerStatefulWidget {
  const QuestionsPage({super.key});

  @override
  ConsumerState<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends ConsumerState<QuestionsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Default to department (false) as requested
    Future.microtask(() {
      ref.read(questionsScopeUniversityProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
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
                                  .read(questionsSelectedYearProvider.notifier)
                                  .state = null;
                              Navigator.pop(context);
                              setState(() {});
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

                        return ListTile(
                          title: Text(
                            isAll ? 'All Years' : year!,
                            style: TextStyle(
                              fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  LucideIcons.check,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                )
                              : null,
                          onTap: () {
                            ref
                                .read(questionsSelectedYearProvider.notifier)
                                .state = year;
                            Navigator.pop(context);
                            setState(() {});
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

  Widget _buildYearFilterTrailing(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedYear = ref.watch(questionsSelectedYearProvider);
    return GestureDetector(
      onTap: () => _showYearFilterSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.calendar,
              size: 14,
              color: selectedYear != null
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              selectedYear ?? 'Year',
              style: TextStyle(
                color: selectedYear != null
                    ? Theme.of(context).primaryColor
                    : (isDark ? Colors.white70 : Colors.grey.shade700),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (selectedYear != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  ref.read(questionsSelectedYearProvider.notifier).state = null;
                  setState(() {});
                },
                child: Icon(
                  LucideIcons.circleX,
                  size: 12,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsPaginationProvider);

    return RedHeaderLayout(
      title: 'Question Bank',
      showSearchBar: true,
      searchHint: 'Search questions...',
      onSearchChanged: (val) {
        ref.read(questionsSearchQueryProvider.notifier).state = val;
      },
      searchTrailing: _buildYearFilterTrailing(context),
      body: questionsAsync.when(
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                  itemCount: state.docs.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.docs.length - 5 &&
                        state.hasMore &&
                        !state.isLoadingMore) {
                      Future.microtask(() {
                        ref
                            .read(questionsPaginationProvider.notifier)
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.circleAlert, color: Colors.red, size: 48),
              const SizedBox(height: Spacing.lg),
              Text('Error: $e'),
              TextButton(
                onPressed: () =>
                    ref.read(questionsPaginationProvider.notifier).refresh(),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
