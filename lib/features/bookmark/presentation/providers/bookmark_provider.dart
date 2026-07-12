import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/di.dart';
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
