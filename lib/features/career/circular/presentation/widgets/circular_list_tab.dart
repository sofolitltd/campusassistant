import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/routes/app_route.dart';
import '../../../jobs/data/models/career_job.dart';
import '../../../jobs/presentation/widgets/shared_job_card.dart';
import '../../../presentation/models/career_feed_item.dart';
import '../providers/circular_provider.dart';
import 'circular_card.dart';

enum _DateFilter { latest, upcoming, outdated }

class CircularListTab extends ConsumerStatefulWidget {
  const CircularListTab({super.key});

  @override
  ConsumerState<CircularListTab> createState() => _CircularListTabState();
}

class _CircularListTabState extends ConsumerState<CircularListTab> {
  String? _categoryId;
  String _search = '';
  CareerJobScope? _scopeFilter;
  _DateFilter _dateFilter = _DateFilter.latest;

  int get _activeFilterCount {
    int count = 0;
    if (_categoryId != null) count++;
    if (_scopeFilter != null) count++;
    if (_dateFilter != _DateFilter.latest) count++;
    return count;
  }

  void _openFilterSheet() {
    final cs = Theme.of(context).colorScheme;
    final categories = ref.read(circularCategoriesProvider).maybeWhen(data: (v) => v, orElse: () => const []);
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusToken.xl)),
      ),
      builder: (context) {
        String? tempCategoryId = _categoryId;
        CareerJobScope? tempScope = _scopeFilter;
        _DateFilter tempDate = _dateFilter;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Spacing.xxl, Spacing.lg, Spacing.xxl, Spacing.xxl),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Filter',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                tempCategoryId = null;
                                tempScope = null;
                                tempDate = _DateFilter.latest;
                              });
                            },
                            child: Text('Reset', style: TextStyle(color: cs.primary)),
                          ),
                        ],
                      ),
                      if (categories.isNotEmpty) ...[
                        const SizedBox(height: Spacing.lg),
                        Text('Category', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: Spacing.sm),
                        Wrap(
                          spacing: Spacing.sm,
                          runSpacing: Spacing.sm,
                          children: [
                            _FilterChip(
                              label: 'All',
                              selected: tempCategoryId == null,
                              onTap: () => setSheetState(() => tempCategoryId = null),
                            ),
                            for (final category in categories)
                              _FilterChip(
                                label: category.name,
                                selected: tempCategoryId == category.id,
                                onTap: () => setSheetState(() => tempCategoryId = category.id),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: Spacing.xl),
                      Text('Scope', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: Spacing.sm),
                      Wrap(
                        spacing: Spacing.sm,
                        runSpacing: Spacing.sm,
                        children: [
                          _FilterChip(
                            label: 'All',
                            selected: tempScope == null,
                            onTap: () => setSheetState(() => tempScope = null),
                          ),
                          _FilterChip(
                            label: 'Batch',
                            selected: tempScope == CareerJobScope.batch,
                            onTap: () => setSheetState(() => tempScope = CareerJobScope.batch),
                          ),
                          _FilterChip(
                            label: 'Department',
                            selected: tempScope == CareerJobScope.department,
                            onTap: () => setSheetState(() => tempScope = CareerJobScope.department),
                          ),
                          _FilterChip(
                            label: 'University',
                            selected: tempScope == CareerJobScope.university,
                            onTap: () => setSheetState(() => tempScope = CareerJobScope.university),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xl),
                      Text('Deadline', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: Spacing.sm),
                      Wrap(
                        spacing: Spacing.sm,
                        runSpacing: Spacing.sm,
                        children: [
                          _FilterChip(
                            label: 'Latest',
                            selected: tempDate == _DateFilter.latest,
                            onTap: () => setSheetState(() => tempDate = _DateFilter.latest),
                          ),
                          _FilterChip(
                            label: 'Upcoming',
                            selected: tempDate == _DateFilter.upcoming,
                            onTap: () => setSheetState(() => tempDate = _DateFilter.upcoming),
                          ),
                          _FilterChip(
                            label: 'Expired',
                            selected: tempDate == _DateFilter.outdated,
                            onTap: () => setSheetState(() => tempDate = _DateFilter.outdated),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _categoryId = tempCategoryId;
                              _scopeFilter = tempScope;
                              _dateFilter = tempDate;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool _passesDateFilter(CareerFeedItem item) {
    if (_dateFilter == _DateFilter.latest) return true;
    DateTime? deadline;
    if (item is CircularFeedItem) {
      deadline = item.circular.deadlineDate;
    } else if (item is SharedJobFeedItem) {
      deadline = item.job.deadlineDate;
    }
    if (deadline == null) return true;
    final isPast = deadline.isBefore(DateTime.now());
    return _dateFilter == _DateFilter.upcoming ? !isPast : isPast;
  }

  @override
  Widget build(BuildContext context) {
    // Keep categories warm so the filter sheet has data ready by the time
    // it's opened, even though this tab no longer renders them inline.
    ref.watch(circularCategoriesProvider);
    final feedAsync = ref.watch(careerFeedProvider((categoryId: _categoryId, search: _search)));
    final cs = Theme.of(context).colorScheme;
    final activeCount = _activeFilterCount;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(LucideIcons.search),
                    isDense: true,
                    contentPadding: .zero,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) => setState(() => _search = value.trim()),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _openFilterSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: cs.outline),
                    borderRadius: RadiusToken.circular(RadiusToken.sm),
                  ),
                  child: Badge(
                    isLabelVisible: activeCount > 0,
                    label: Text('$activeCount', style: const TextStyle(fontSize: 10)),
                    child: Icon(LucideIcons.slidersHorizontal, size: 20, color: cs.onSurface),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: feedAsync.when(
            data: (items) {
              final filtered = items.where((item) {
                final scopeOk = _scopeFilter == null ||
                    (item is SharedJobFeedItem && item.job.scope == _scopeFilter);
                final dateOk = _passesDateFilter(item);
                return scopeOk && dateOk;
              }).toList();
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.fileText, size: 48, color: cs.outline),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : cs.surfaceContainerLow,
          borderRadius: RadiusToken.circular(RadiusToken.sm),
          border: Border.all(color: selected ? cs.primary : cs.outlineVariant),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? cs.onPrimaryContainer : cs.onSurface,
          ),
        ),
      ),
    );
  }
}
