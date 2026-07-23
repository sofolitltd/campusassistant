import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../../presentation/providers/career_refresh_provider.dart';
import '../../data/models/career_job.dart';

final myCareerJobsProvider = FutureProvider<List<CareerJob>>((ref) async {
  ref.watch(careerRefreshProvider);
  final repo = ref.watch(careerJobRepositoryProvider);
  return repo.getMyJobs();
});

final careerJobByIdProvider =
    FutureProvider.family<CareerJob?, String>((ref, id) async {
  final jobs = await ref.watch(myCareerJobsProvider.future);
  for (final job in jobs) {
    if (job.id == id) return job;
  }
  return null;
});

/// Peer-shared jobs at the given scope, refetched whenever a mutation bumps
/// careerRefreshProvider (e.g. someone shares a new job).
final sharedJobsByScopeProvider =
    FutureProvider.family<List<CareerJob>, CareerJobScope>((ref, scope) async {
  ref.watch(careerRefreshProvider);
  final repo = ref.watch(careerJobRepositoryProvider);
  return repo.getSharedJobs(scope);
});

/// All peer-shared jobs visible to the viewer, across every scope at once
/// (a job's own `scope` field can only ever match one of the three calls,
/// so no dedup is needed) — feeds a single merged list with a per-card
/// scope badge instead of separate Batch/Department/University tabs.
final allSharedJobsProvider = FutureProvider<List<CareerJob>>((ref) async {
  final batch = ref.watch(sharedJobsByScopeProvider(CareerJobScope.batch).future);
  final department = ref.watch(sharedJobsByScopeProvider(CareerJobScope.department).future);
  final university = ref.watch(sharedJobsByScopeProvider(CareerJobScope.university).future);
  final results = await Future.wait([batch, department, university]);
  final jobs = results.expand((list) => list).toList();
  jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return jobs;
});

class CareerJobActions {
  final Ref ref;
  CareerJobActions(this.ref);

  Future<CareerJob> createJob(CareerJob draft) async {
    final job = await ref.read(careerJobRepositoryProvider).createJob(draft);
    ref.read(careerRefreshProvider.notifier).bump();
    return job;
  }

  Future<CareerJob> updateJob(String id, CareerJob draft) async {
    final job = await ref.read(careerJobRepositoryProvider).updateJob(id, draft);
    ref.read(careerRefreshProvider.notifier).bump();
    return job;
  }

  Future<void> setStatus(String id, CareerJobStatus status) async {
    await ref.read(careerJobRepositoryProvider).setStatus(id, status);
    ref.read(careerRefreshProvider.notifier).bump();
  }

  Future<void> deleteJob(String id) async {
    await ref.read(careerJobRepositoryProvider).deleteJob(id);
    ref.read(careerRefreshProvider.notifier).bump();
  }
}

final careerJobActionsProvider = Provider<CareerJobActions>((ref) {
  return CareerJobActions(ref);
});
