import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
import '/routes/app_route.dart';
import '../../data/models/lost_found_item.dart';
import '../providers/lost_found_provider.dart';
import '../widgets/lost_found_card.dart';

class LostFoundPage extends ConsumerStatefulWidget {
  const LostFoundPage({super.key});

  @override
  ConsumerState<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends ConsumerState<LostFoundPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String? _categoryId;
  String _search = '';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _search = value.trim());
    });
  }

  LostFoundFeedTab get _activeTab => switch (_tabController.index) {
        1 => LostFoundFeedTab.found,
        2 => LostFoundFeedTab.myPosts,
        _ => LostFoundFeedTab.lost,
      };

  @override
  Widget build(BuildContext context) {
    // Rebuild providers whenever a mutation bumps the refresh counter.
    ref.watch(lostFoundRefreshProvider);
    final categoriesAsync = ref.watch(lostFoundCategoriesProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoute.lostFoundCreate.name),
        icon: const Icon(Icons.add),
        label: const Text('Post Item'),
      ),
      body: CustomHeaderLayout(
        title: 'Lost & Found',
        searchHint: 'Search title, location...',
        onSearchChanged: _onSearchChanged,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SectionTabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Lost'),
                  Tab(text: 'Found'),
                  Tab(text: 'My Posts'),
                ],
              ),
            ),
            if (_activeTab != LostFoundFeedTab.myPosts)
              categoriesAsync.when(
                data: (categories) => SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _CategoryChip(
                        label: 'All',
                        selected: _categoryId == null,
                        onTap: () => setState(() => _categoryId = null),
                      ),
                      for (final category in categories)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _CategoryChip(
                            label: category.name,
                            selected: _categoryId == category.id,
                            onTap: () => setState(() => _categoryId = category.id),
                          ),
                        ),
                    ],
                  ),
                ),
                loading: () => const SizedBox(height: 40),
                error: (_, _) => const SizedBox.shrink(),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final feedAsync = ref.watch(lostFoundFeedProvider(
                    (tab: _activeTab, categoryId: _categoryId, search: _search),
                  ));
                  return feedAsync.when(
                    data: (items) => _ItemsGrid(items: items),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('Failed to load items: $err')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _ItemsGrid extends StatelessWidget {
  final List<LostFoundItem> items;
  const _ItemsGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined, size: 48, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12),
              const Text('Nothing here yet'),
            ],
          ),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return LostFoundCard(
          item: item,
          onTap: () => context.pushNamed(
            AppRoute.lostFoundItemDetails.name,
            pathParameters: {'itemId': item.id},
          ),
        );
      },
    );
  }
}
