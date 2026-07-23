import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';
import '../../data/models/career_job.dart';
import '../providers/career_job_provider.dart';
import 'job_card.dart';

class JobsListTab extends ConsumerStatefulWidget {
  const JobsListTab({super.key});

  @override
  ConsumerState<JobsListTab> createState() => _JobsListTabState();
}

class _JobsListTabState extends ConsumerState<JobsListTab> {
  CareerJobStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(myCareerJobsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _statusFilter == null,
                  onSelected: (_) => setState(() => _statusFilter = null),
                ),
                for (final status in CareerJobStatus.values)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(status.name[0].toUpperCase() + status.name.substring(1)),
                      selected: _statusFilter == status,
                      onSelected: (_) => setState(() => _statusFilter = status),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: jobsAsync.when(
            data: (jobs) {
              final filtered = _statusFilter == null
                  ? jobs
                  : jobs.where((j) => j.status == _statusFilter).toList();
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
