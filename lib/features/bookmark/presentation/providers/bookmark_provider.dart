import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
import '/features/resource/data/models/resource_model.dart';
import '/features/resource/domain/entities/resource.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../data/repositories/bookmark_repository_impl.dart';

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return BookmarkRepositoryImpl(
    apiClient: apiClient,
    cacheManager: cacheManager,
    connectivity: connectivity,
  );
});

final userBookmarksProvider = FutureProvider.family<List<Bookmark>, String>((
  ref,
  userId,
) async {
  final repo = ref.watch(bookmarkRepositoryProvider);
  final result = await repo.getBookmarks(userId);
  return result.fold((failure) => [], (bookmarks) => bookmarks);
});

final entityDetailProvider =
    FutureProvider.family<dynamic, ({String type, String id})>((
      ref,
      arg,
    ) async {
      final repo = ref.watch(bookmarkRepositoryProvider);
      final result = await repo.getEntityDetail(arg.type, arg.id);
      return result.fold((failure) => null, (detail) => detail);
    });

/// All of the user's bookmarked resources — intentionally the same full list
/// everywhere a bookmark button appears (course page, chapter page, the
/// dedicated Bookmarks page, …), so bookmarking something from one place
/// means it's reachable from any of them, not just the place it was saved
/// from.
final scopedBookmarkResourcesProvider = FutureProvider.autoDispose
    .family<List<Resource>, String>((ref, userId) async {
      if (userId.isEmpty) return const [];
      final bookmarks = await ref.watch(userBookmarksProvider(userId).future);
      final details = await Future.wait(
        bookmarks.map(
          (b) => ref.watch(
            entityDetailProvider((type: b.entityType, id: b.entityId)).future,
          ),
        ),
      );

      final resources = <Resource>[];
      for (final detail in details) {
        if (detail is! Map<String, dynamic>) continue;
        try {
          resources.add(ResourceModel.fromJson(detail).toEntity());
        } catch (_) {
          continue;
        }
      }
      return resources;
    });
