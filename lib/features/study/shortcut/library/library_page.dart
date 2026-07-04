import 'dart:async';
import 'dart:ui';
import 'package:campusassistant/features/study/widgets/content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../presentation/providers/library_provider.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Widget _buildSmoothTabControl() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmoothTab('Department', 0, isDark),
                  const SizedBox(width: 4),
                  _buildSmoothTab('University', 1, isDark),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSmoothTab(String label, int index, bool isDark) {
    final double animationValue = _tabController.animation!.value;
    final double progress = (1.0 - (animationValue - index).abs()).clamp(
      0.0,
      1.0,
    );

    final Color activeColor = isDark ? Colors.white : Colors.black;
    final Color inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white;
    final Color activeTextColor = isDark ? Colors.black : Colors.white;
    final Color inactiveTextColor = Colors.grey.shade600;

    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 32,
        decoration: BoxDecoration(
          color: Color.lerp(inactiveColor, activeColor, progress),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color.lerp(
              isDark ? Colors.white24 : Colors.grey.shade300,
              isDark ? Colors.white24 : Colors.grey.shade300,
              progress,
            )!,
            width: 1,
          ),
          boxShadow: progress > 0.5
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.1 * progress),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Color.lerp(inactiveTextColor, activeTextColor, progress),
              fontWeight: progress > 0.5 ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingSearchBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        ref
                            .read(librarySearchQueryProvider.notifier)
                            .state = val;
                      });
                      setState(() {});
                    },
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by book, author or course...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade500,
                        fontSize: 12,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        child: Icon(
                          LucideIcons.search,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 32),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                ref
                                    .read(librarySearchQueryProvider.notifier)
                                    .state = '';
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Icon(
                                  LucideIcons.circleX,
                                  size: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(
                        maxHeight: 28,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
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

  @override
  Widget build(BuildContext context) {
    final libraryAsync = ref.watch(libraryPaginationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Library'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSmoothTabControl(),
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
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
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
                                      .read(libraryPaginationProvider.notifier)
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
                                          'Loading more books...',
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
                        const SizedBox(height: 16),
                        Text('Error: $e'),
                        TextButton(
                          onPressed: () =>
                              ref.read(libraryPaginationProvider.notifier).refresh(),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildFloatingSearchBar(context),
        ],
      ),
    );
  }
}
