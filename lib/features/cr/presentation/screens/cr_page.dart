import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/widgets/smooth_tab_control.dart';
import '../../data/models/cr_model.dart';
import '../providers/cr_provider.dart';
import 'cr_card.dart';

class CrPage extends ConsumerStatefulWidget {
  const CrPage({super.key});

  @override
  ConsumerState<CrPage> createState() => _CrPageState();
}

class _CrPageState extends ConsumerState<CrPage>
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
    final crAsync = ref.watch(crProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Representative'),
        centerTitle: true,
      ),
      body: crAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (crList) {
          final activeCrs = crList.where((cr) => cr.isCurrent).toList();
          final archivedCrs = crList.where((cr) => !cr.isCurrent).toList();

          return Column(
            children: [
              SmoothTabControl(
                tabController: _tabController,
                labels: const ['Active', 'Archived'],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _CrList(crs: activeCrs, emptyMessage: 'No active CRs found'),
                    _CrList(
                      crs: archivedCrs,
                      emptyMessage: 'No archived records',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CrList extends StatelessWidget {
  final List<CrModel> crs;
  final String emptyMessage;

  const _CrList({required this.crs, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (crs.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    final batchGroup = <String, List<CrModel>>{};
    for (final cr in crs) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              batch,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cr = data[index];
                return CrCard(cr: cr);
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
