import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/widgets/app_choice_chip.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
import '/routes/app_route.dart';
import '../../data/models/lost_found_item.dart';
import '../providers/lost_found_provider.dart';
import '../widgets/lost_found_card.dart';
import '/core/theme/tokens/app_spacing.dart';

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
      // Lifted clear of the bottom search capsule.
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton.extended(
          onPressed: () => context.pushNamed(AppRoute.lostFoundCreate.name),
          icon: const Icon(Icons.add),
          label: const Text('Post item'),
        ),
      ),
      body: CustomHeaderLayout(
        searchAtBottom: true,
        title: 'Lost & Found',
        searchHint: 'Search title, location...',
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
                  Tab(text: 'Lost'),
                  Tab(text: 'Found'),
                  Tab(text: 'My Posts'),
                ],
              ),
            ),
            if (_activeTab != LostFoundFeedTab.myPosts)
              categoriesAsync.when(
                data: (categories) => SizedBox(
                  height: AppChoiceChip.rowHeight,
                  child: ListView.separated(
                    scrollDirection: .horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: Spacing.sm),
                    itemBuilder: (context, index) {
                      final category = index == 0
                          ? null
                          : categories[index - 1];
                      return AppChoiceChip(
                        label: category?.name ?? 'All',
                        selected: _categoryId == category?.id,
                        onTap: () => setState(() => _categoryId = category?.id),
                      );
                    },
                  ),
                ),
                loading: () => const SizedBox(height: AppChoiceChip.rowHeight),
                error: (_, _) => const SizedBox.shrink(),
              ),
            const SizedBox(height: Spacing.sm),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final feedAsync = ref.watch(
                    lostFoundFeedProvider((
                      tab: _activeTab,
                      categoryId: _categoryId,
                      search: _search,
                    )),
                  );
                  return feedAsync.when(
                    data: (items) => _ItemsList(items: items),
                    loading: () =>
                        const Center(child: CupertinoActivityIndicator()),
                    error: (err, _) =>
                        Center(child: Text('Failed to load items: $err')),
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

class _ItemsList extends StatelessWidget {
  final List<LostFoundItem> items;
  const _ItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xxl),
          child: Column(
            mainAxisSize: .min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: Spacing.md),
              const Text('Nothing here yet'),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.lg),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
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
