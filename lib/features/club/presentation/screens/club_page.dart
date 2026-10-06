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
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_font_size.dart';

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
              mainAxisAlignment: .center,
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
                    fontWeight: .bold,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
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
                  scrollDirection: .horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
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
            const SizedBox(height: Spacing.sm),
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
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.lg,
                        0,
                        Spacing.lg,
                        100,
                      ),
                      itemCount: clubs.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: Spacing.lg),
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
    return Padding(
      padding: const EdgeInsets.only(right: Spacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          decoration: BoxDecoration(
            color: selected ? primaryColor : (context.colors.surfaceAlt),
            borderRadius: BorderRadius.circular(RadiusToken.xl),
            border: Border.all(
              color: selected ? primaryColor : (context.colors.borderStrong),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: FontSizeToken.sm,
              fontWeight: .w600,
              color: selected
                  ? context.colors.onPrimary
                  : (context.colors.textMuted),
            ),
          ),
        ),
      ),
    );
  }
}
