import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';
import '../../../jobs/data/models/career_job.dart';
import '../../../jobs/presentation/widgets/shared_job_card.dart';
import '../../../presentation/models/career_feed_item.dart';
import '../providers/circular_provider.dart';
import 'circular_card.dart';

class CircularListTab extends ConsumerStatefulWidget {
  const CircularListTab({super.key});

  @override
  ConsumerState<CircularListTab> createState() => _CircularListTabState();
}

class _CircularListTabState extends ConsumerState<CircularListTab> {
  String? _categoryId;
  String _search = '';
  CareerJobScope? _scopeFilter; // null = All; only narrows shared-job cards

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(circularCategoriesProvider);
    final feedAsync = ref.watch(careerFeedProvider((categoryId: _categoryId, search: _search)));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) => setState(() => _search = value.trim()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<CareerJobScope?>(
                  initialValue: _scopeFilter,
                  isDense: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: CareerJobScope.batch, child: Text('Batch')),
                    DropdownMenuItem(value: CareerJobScope.department, child: Text('Dept')),
                    DropdownMenuItem(value: CareerJobScope.university, child: Text('Uni')),
                  ],
                  onChanged: (value) => setState(() => _scopeFilter = value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        categoriesAsync.when(
          data: (categories) => SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _categoryId == null,
                  onSelected: (_) => setState(() => _categoryId = null),
                ),
                for (final category in categories)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(category.name),
                      selected: _categoryId == category.id,
                      onSelected: (_) => setState(() => _categoryId = category.id),
                    ),
                  ),
              ],
            ),
          ),
          loading: () => const SizedBox(height: 36),
          error: (_, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: feedAsync.when(
            data: (items) {
              final filtered = _scopeFilter == null
                  ? items
                  : items.where((item) => item is! SharedJobFeedItem || item.job.scope == _scopeFilter).toList();
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.fileText, size: 48, color: Theme.of(context).colorScheme.outline),
                      const SizedBox(height: 12),
                      const Text('Nothing here yet'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return switch (item) {
                    CircularFeedItem(:final circular) => CircularCard(
                        circular: circular,
                        onTap: () => context.pushNamed(
                          AppRoute.careerCircularDetails.name,
                          pathParameters: {'circularId': circular.id},
                        ),
                      ),
                    SharedJobFeedItem(:final job) => SharedJobCard(job: job),
                  };
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Failed to load: $err')),
          ),
        ),
      ],
    );
  }
}
