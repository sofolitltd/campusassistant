import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../../jobs/presentation/providers/career_job_provider.dart';
import '../../../presentation/models/career_feed_item.dart';
import '../../../presentation/providers/career_refresh_provider.dart';
import '../../data/models/career_circular.dart';
import '../../data/models/circular_category.dart';

final circularCategoriesProvider =
    FutureProvider<List<CircularCategory>>((ref) async {
  final repo = ref.watch(circularRepositoryProvider);
  return repo.getCategories();
});

final circularFeedProvider = FutureProvider.family<List<CareerCircular>,
    ({String? categoryId, String? search})>((ref, params) async {
  final repo = ref.watch(circularRepositoryProvider);
  final profile = await ref.watch(userProvider.future);
  return repo.getCircularsByLocation(
    universityId: profile.university,
    departmentId: profile.department,
    categoryId: params.categoryId,
    search: params.search,
  );
});

/// Unified feed: official Circulars (category/search filtered) merged with
/// every peer-shared Job, sorted newest-first — one list instead of two
/// separate sections, each card indicating its own origin (Official vs.
/// Shared by a student).
final careerFeedProvider = FutureProvider.family<List<CareerFeedItem>,
    ({String? categoryId, String? search})>((ref, params) async {
  final circulars = await ref.watch(circularFeedProvider(params).future);
  final jobs = await ref.watch(allSharedJobsProvider.future);
  final items = <CareerFeedItem>[
    ...circulars.map(CircularFeedItem.new),
    ...jobs.map(SharedJobFeedItem.new),
  ];
  items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return items;
});

final circularDetailProvider =
    FutureProvider.family<CareerCircular, String>((ref, id) async {
  final repo = ref.watch(circularRepositoryProvider);
  return repo.getCircularById(id);
});

class CircularActions {
  final Ref ref;
  CircularActions(this.ref);

  Future<void> recordView(String id) async {
    await ref.read(circularRepositoryProvider).recordView(id);
  }

  /// "Save to My Jobs" — copies the circular into a job owned by the
  /// caller, and bumps the shared refresh counter so the My Jobs tab
  /// picks it up next time it's viewed.
  Future<void> saveToMyJobs(String circularId) async {
    await ref.read(circularRepositoryProvider).saveToMyJobs(circularId);
    ref.read(careerRefreshProvider.notifier).bump();
  }
}

final circularActionsProvider = Provider<CircularActions>((ref) {
  return CircularActions(ref);
});
