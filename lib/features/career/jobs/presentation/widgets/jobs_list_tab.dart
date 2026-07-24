import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/routes/app_route.dart';
import '../../data/models/career_job.dart';
import '../providers/career_job_provider.dart';
import 'job_card.dart';

enum _DeadlineFilter { all, upcoming, expired }

class JobsListTab extends ConsumerStatefulWidget {
  const JobsListTab({super.key});

  @override
  ConsumerState<JobsListTab> createState() => _JobsListTabState();
}

class _JobsListTabState extends ConsumerState<JobsListTab> {
  String _search = '';
  CareerJobStatus? _statusFilter;
  _DeadlineFilter _deadlineFilter = _DeadlineFilter.all;

  int get _activeFilterCount {
    int count = 0;
    if (_statusFilter != null) count++;
    if (_deadlineFilter != _DeadlineFilter.all) count++;
    return count;
  }

  void _openFilterSheet() {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusToken.xl)),
      ),
      builder: (context) {
        CareerJobStatus? tempStatus = _statusFilter;
        _DeadlineFilter tempDeadline = _deadlineFilter;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Spacing.xxl, Spacing.lg, Spacing.xxl, Spacing.xxl),
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
                              tempStatus = null;
                              tempDeadline = _DeadlineFilter.all;
                            });
                          },
                          child: Text('Reset', style: TextStyle(color: cs.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),
                    Text('Status', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: Spacing.sm),
                    Wrap(
                      spacing: Spacing.sm,
                      runSpacing: Spacing.sm,
                      children: [
                        _FilterChip(
                          label: 'All',
                          selected: tempStatus == null,
                          onTap: () => setSheetState(() => tempStatus = null),
                        ),
                        for (final status in CareerJobStatus.values)
                          _FilterChip(
                            label: status.name[0].toUpperCase() + status.name.substring(1),
                            selected: tempStatus == status,
                            onTap: () => setSheetState(() => tempStatus = status),
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
                          label: 'All',
                          selected: tempDeadline == _DeadlineFilter.all,
                          onTap: () => setSheetState(() => tempDeadline = _DeadlineFilter.all),
                        ),
                        _FilterChip(
                          label: 'Upcoming',
                          selected: tempDeadline == _DeadlineFilter.upcoming,
                          onTap: () => setSheetState(() => tempDeadline = _DeadlineFilter.upcoming),
                        ),
                        _FilterChip(
                          label: 'Expired',
                          selected: tempDeadline == _DeadlineFilter.expired,
                          onTap: () => setSheetState(() => tempDeadline = _DeadlineFilter.expired),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _statusFilter = tempStatus;
                            _deadlineFilter = tempDeadline;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool _passesDeadlineFilter(CareerJob job) {
    if (_deadlineFilter == _DeadlineFilter.all) return true;
    if (job.deadlineDate == null) return true;
    return _deadlineFilter == _DeadlineFilter.upcoming ? !job.isPastDeadline : job.isPastDeadline;
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(myCareerJobsProvider);
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
                  onChanged: (value) => setState(() => _search = value.trim()),
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
          child: jobsAsync.when(
            data: (jobs) {
              final query = _search.toLowerCase();
              final filtered = jobs.where((job) {
                final statusOk = _statusFilter == null || job.status == _statusFilter;
                final deadlineOk = _passesDeadlineFilter(job);
                final searchOk = query.isEmpty ||
                    job.title.toLowerCase().contains(query) ||
                    job.organization.toLowerCase().contains(query);
                return statusOk && deadlineOk && searchOk;
              }).toList();
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.briefcase, size: 48, color: Theme.of(context).colorScheme.outline),
                      const SizedBox(height: 12),
                      const Text('No jobs yet'),
                      const SizedBox(height: 4),
                      const Text('Save a circular or add one manually.'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final job = filtered[index];
                  return JobCard(
                    job: job,
                    onTap: () => context.pushNamed(
                      AppRoute.careerJobDetails.name,
                      pathParameters: {'jobId': job.id},
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Failed to load jobs: $err')),
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
