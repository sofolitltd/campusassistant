import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
import '/features/club/presentation/providers/club_provider.dart';
import '/features/club/presentation/widgets/club_card.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_spacing.dart';

class ClubsPage extends ConsumerStatefulWidget {
  const ClubsPage({super.key});

  @override
  ConsumerState<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends ConsumerState<ClubsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderLayout(
      title: 'Clubs & Organizations',
      searchHint: 'Search clubs...',
      actionIcon: LucideIcons.plus,
      onActionTap: () => context.push(AppRoute.suggestClub.path),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SectionTabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Department'),
                Tab(text: 'University'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ClubsList(filterType: 'department'),
                ClubsList(filterType: 'university'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _clubCategories = [
  'Academic',
  'Cultural',
  'Sports',
  'Technology',
  'Arts',
  'Social Service',
  'Debate',
  'Other',
];

class ClubsList extends ConsumerStatefulWidget {
  final String filterType;

  const ClubsList({super.key, required this.filterType});

  @override
  ConsumerState<ClubsList> createState() => _ClubsListState();
}

class _ClubsListState extends ConsumerState<ClubsList> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final asyncClubs = ref.watch(clubsListProvider(widget.filterType));

    return asyncClubs.when(
      data: (allClubs) {
        final categoriesPresent = _clubCategories
            .where((c) => allClubs.any((club) => club.category == c))
            .toList();
        final clubs = _selectedCategory == null
            ? allClubs
            : allClubs.where((c) => c.category == _selectedCategory).toList();

        if (allClubs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.users,
                  size: 64,
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.5),
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  'No clubs found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to add one!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            if (categoriesPresent.isNotEmpty)
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _CategoryChip(
                      label: 'All',
                      selected: _selectedCategory == null,
                      onTap: () => setState(() => _selectedCategory = null),
                    ),
                    ...categoriesPresent.map(
                      (cat) => _CategoryChip(
                        label: cat,
                        selected: _selectedCategory == cat,
                        onTap: () => setState(() => _selectedCategory = cat),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: clubs.isEmpty
                  ? Center(
                      child: Text(
                        'No clubs in this category',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: clubs.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) =>
                          ClubCard(club: clubs[index]),
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected
                ? primaryColor
                : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? primaryColor
                  : (isDark ? Colors.white10 : Colors.grey.shade300),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.grey.shade700),
            ),
          ),
        ),
      ),
    );
  }
}
