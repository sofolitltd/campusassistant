import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '/core/di.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/search_result.dart';

/// Raw text typed into the search box (debounced upstream by the page).
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Selected category filter — plain string keys matching backend `type`
/// values (resource, notice, course, club, association, teacher, staff,
/// marketplace, lost_found, career), or 'all'.
final searchCategoryProvider = StateProvider<String>((ref) => 'all');

/// Resource `type` values (see `Resource.type`) exposed as their own chips
/// instead of one combined "Resources" chip — the backend only knows the
/// broad `resource` category, so these are requested as `types: ['resource']`
/// and filtered down to the matching subtype client-side.
const resourceSubtypes = <String>{'note', 'book', 'question', 'syllabus', 'video'};

/// Fetches results for the current query + category. Returns `null` (no
/// network call) while the trimmed query is under 2 characters.
final searchResultsProvider =
    FutureProvider.autoDispose<SearchResults?>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  final category = ref.watch(searchCategoryProvider);

  if (query.length < 2) return null;

  final repo = ref.watch(searchRepositoryProvider);
  final profile = await ref.watch(userProvider.future);

  final isSubtype = resourceSubtypes.contains(category);
  final results = await repo.search(
    query: query,
    types: category == 'all' ? null : [isSubtype ? 'resource' : category],
    universityId: profile.university,
    departmentId: profile.department,
    // Fetching a resource subtype filters the "resource" bucket down
    // further client-side, so ask for a bigger pool than the default limit
    // to avoid ending up with too few (or zero) matches after filtering.
    limitPerType: isSubtype ? 20 : null,
  );

  if (!isSubtype) return results;
  return results.copyWith(
    resources: results.resources.where((r) => r.type == category).toList(),
  );
});
