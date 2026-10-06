import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import '/core/widgets/app_choice_chip.dart';
import '/core/widgets/glass_search_bar.dart';
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xl),
        ),
      ),
      builder: (context) {
        CareerJobStatus? tempStatus = _statusFilter;
        _DeadlineFilter tempDeadline = _deadlineFilter;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.xxl,
                  Spacing.lg,
                  Spacing.xxl,
                  Spacing.xxl,
                ),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Filter',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: .w900),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              tempStatus = null;
                              tempDeadline = _DeadlineFilter.all;
                            });
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: cs.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),
                    Text(
                      'Status',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Wrap(
                      spacing: Spacing.sm,
                      runSpacing: Spacing.sm,
                      children: [
                        AppChoiceChip(
                          label: 'All',
                          selected: tempStatus == null,
                          onTap: () => setSheetState(() => tempStatus = null),
                        ),
                        for (final status in CareerJobStatus.values)
                          AppChoiceChip(
                            label:
                                status.name[0].toUpperCase() +
                                status.name.substring(1),
                            selected: tempStatus == status,
                            onTap: () =>
                                setSheetState(() => tempStatus = status),
                          ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xl),
                    Text(
                      'Deadline',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Wrap(
                      spacing: Spacing.sm,
                      runSpacing: Spacing.sm,
                      children: [
                        AppChoiceChip(
                          label: 'All',
                          selected: tempDeadline == _DeadlineFilter.all,
                          onTap: () => setSheetState(
                            () => tempDeadline = _DeadlineFilter.all,
                          ),
                        ),
                        AppChoiceChip(
                          label: 'Upcoming',
                          selected: tempDeadline == _DeadlineFilter.upcoming,
                          onTap: () => setSheetState(
                            () => tempDeadline = _DeadlineFilter.upcoming,
                          ),
                        ),
                        AppChoiceChip(
                          label: 'Expired',
                          selected: tempDeadline == _DeadlineFilter.expired,
                          onTap: () => setSheetState(
                            () => tempDeadline = _DeadlineFilter.expired,
                          ),
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
    return _deadlineFilter == _DeadlineFilter.upcoming
        ? !job.isPastDeadline
        : job.isPastDeadline;
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(myCareerJobsProvider);
    final activeCount = _activeFilterCount;

    return Column(
      children: [
        Expanded(
          child: jobsAsync.when(
            data: (jobs) {
              final query = _search.toLowerCase();
              final filtered = jobs.where((job) {
                final statusOk =
                    _statusFilter == null || job.status == _statusFilter;
                final deadlineOk = _passesDeadlineFilter(job);
                final searchOk =
                    query.isEmpty ||
                    job.title.toLowerCase().contains(query) ||
                    job.organization.toLowerCase().contains(query);
                return statusOk && deadlineOk && searchOk;
              }).toList();
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: .min,
                    children: [
                      Icon(
                        LucideIcons.briefcase,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: Spacing.md),
                      const Text('No jobs yet'),
                      const SizedBox(height: Spacing.xs),
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
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, _) => Center(child: Text('Failed to load jobs: $err')),
          ),
        ),
        GlassSearchDock(
          hint: 'Search jobs...',
          onChanged: (value) => setState(() => _search = value.trim()),
          action: GlassCircleButton(
            icon: LucideIcons.slidersHorizontal,
            tooltip: 'Filter',
            active: activeCount > 0,
            onTap: _openFilterSheet,
          ),
        ),
      ],
    );
  }
}
