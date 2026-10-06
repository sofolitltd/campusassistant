import 'dart:async';
import '/features/resource/presentation/widgets/resource_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/section_tab_bar.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../presentation/providers/library_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(libraryScopeUniversityProvider.notifier).state =
            _tabController.index == 1;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(librarySearchQueryProvider.notifier).state = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final libraryAsync = ref.watch(libraryPaginationProvider);

    return CustomHeaderLayout(
      title: 'Academic Library',
      showSearchBar: true,
      searchAtBottom: true,
      searchHint: 'Search by book, author or course...',
      onSearchChanged: _onSearchChanged,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.lg,
              Spacing.lg,
              Spacing.sm,
            ),
            child: SectionTabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Department'),
                Tab(text: 'University'),
              ],
            ),
          ),
          Expanded(
            child: libraryAsync.when(
              data: (state) {
                if (state.docs.isEmpty && !state.isLoadingMore) {
                  return const Center(child: Text('No books found.'));
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                        itemCount: state.docs.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.docs.length - 5 &&
                              state.hasMore &&
                              !state.isLoadingMore) {
                            Future.microtask(() {
                              ref
                                  .read(libraryPaginationProvider.notifier)
                                  .loadNextPage();
                            });
                          }

                          if (index < state.docs.length) {
                            final doc = state.docs[index];
                            return ResourceCard(resource: doc);
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Spacing.lg,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CupertinoActivityIndicator(),
                                    ),
                                    SizedBox(width: Spacing.sm),
                                    Text(
                                      'Loading more books...',
                                      style: TextStyle(
                                        fontSize: FontSizeToken.sm,
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
              loading: () => const Center(child: CupertinoActivityIndicator()),
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
                          .read(libraryPaginationProvider.notifier)
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
    );
  }
}
