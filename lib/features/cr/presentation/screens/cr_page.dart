import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../data/models/cr_model.dart';
import '../providers/cr_provider.dart';
import 'cr_card.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class CrPage extends ConsumerStatefulWidget {
  const CrPage({super.key});

  @override
  ConsumerState<CrPage> createState() => _CrPageState();
}

class _CrPageState extends ConsumerState<CrPage>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
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
    final crAsync = ref.watch(crProvider);

    return CustomHeaderLayout(
      title: 'Class Representative',
      searchAtBottom: true,
      searchHint: 'Search class representatives...',
      onSearchChanged: (value) => setState(() => _searchQuery = value),
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
                Tab(text: 'Active'),
                Tab(text: 'Archived'),
              ],
            ),
          ),
          Expanded(
            child: crAsync.when(
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (crList) {
                final activeCrs = crList.where((cr) => cr.isCurrent).toList();
                final archivedCrs = crList
                    .where((cr) => !cr.isCurrent)
                    .toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _CrList(
                      crs: activeCrs,
                      searchQuery: _searchQuery,
                      emptyMessage: 'No active CRs found',
                    ),
                    _CrList(
                      crs: archivedCrs,
                      searchQuery: _searchQuery,
                      emptyMessage: 'No archived records',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CrList extends StatelessWidget {
  final List<CrModel> crs;
  final String searchQuery;
  final String emptyMessage;

  const _CrList({
    required this.crs,
    required this.searchQuery,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    // Filter CRs by search query
    final filteredCrs = crs.where((cr) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      return cr.name.toLowerCase().contains(q) ||
          cr.batch.toLowerCase().contains(q);
    }).toList();

    if (filteredCrs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              searchQuery.isNotEmpty ? LucideIcons.searchX : LucideIcons.userX,
              size: 48,
              color: context.colors.borderStrong,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              searchQuery.isNotEmpty ? 'No matches found' : emptyMessage,
              style: TextStyle(
                color: context.colors.textSubtle,
                fontWeight: .w500,
              ),
            ),
          ],
        ),
      );
    }

    final batchGroup = <String, List<CrModel>>{};
    for (final cr in filteredCrs) {
      batchGroup.putIfAbsent(cr.batch, () => []).add(cr);
    }

    final batches = batchGroup.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 800
            ? MediaQuery.of(context).size.width * .2
            : 16,
        vertical: 16,
      ),
      itemCount: batches.length,
      itemBuilder: (context, index) {
        final batch = batches[index];
        final data = batchGroup[batch]!;

        return Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              batch,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: .bold,
                fontSize: FontSizeToken.xl,
              ),
            ),
            const SizedBox(height: Spacing.md),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
              itemBuilder: (context, index) {
                final cr = data[index];
                return CrCard(cr: cr);
              },
            ),
            const SizedBox(height: Spacing.lg),
          ],
        );
      },
    );
  }
}
