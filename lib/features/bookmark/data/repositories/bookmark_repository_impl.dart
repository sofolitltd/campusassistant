import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '/core/cache/cache_manager.dart';
import '/core/cache/connectivity_service.dart';
import '/core/error/failures.dart';
import '/core/network/api_client.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../models/bookmark_model.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final ApiClient apiClient;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  BookmarkRepositoryImpl({
    required this.apiClient,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Bookmark>>> getBookmarks(String userId) async {
    final cacheKey = 'bookmark_user_$userId';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final response = await apiClient.get(
          '/bookmarks',
          queryParameters: {'user_id': userId},
        );
        final dynamic responseData = response.data;
        final List<dynamic> data;
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map<String, dynamic>) {
          data = (responseData['data'] as List<dynamic>?) ?? [];
        } else {
          data = [];
        }
        // Bookmarks only exist for resources in this app — 'content' is a
        // legacy alias for the same underlying resource entity (written by
        // an older card widget). Anything else (e.g. a stray 'community_post'
        // row) has no matching detail endpoint and would 404 below.
        final bookmarks = data
            .map((json) => BookmarkModel.fromJson(json))
            .where(
              (b) => b.entityType == 'resource' || b.entityType == 'content',
            )
            .toList();

        // Cache the result (post-filter, so stale/foreign entity types
        // never get cached either)
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: bookmarks.map((b) => b.toJson()).toList(),
          ttl: CacheTTL.bookmark,
        );

        return Right(bookmarks.map((m) => m.toEntity()).toList());
      } catch (e) {
        debugPrint('[BookmarkRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(entityType: cacheKey);
      if (cachedData.isNotEmpty) {
        final bookmarks = cachedData
            .map((json) => BookmarkModel.fromJson(json))
            .toList();
        debugPrint(
          '[BookmarkRepo] Returning ${bookmarks.length} cached bookmarks',
        );
        return Right(bookmarks.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      debugPrint('[BookmarkRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection and no cached bookmark data available',
        ),
      );
    }

    return Left(ServerFailure('Failed to fetch bookmarks'));
  }

  @override
  Future<Either<Failure, void>> addBookmark(Bookmark bookmark) async {
    try {
      final model = BookmarkModel(
        id: bookmark.id,
        userId: bookmark.userId,
        entityType: bookmark.entityType,
        entityId: bookmark.entityId,
      );
      await apiClient.post('/bookmarks', data: model.toJson());
      await cacheManager.invalidate('bookmark_user_${bookmark.userId}');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String id) async {
    try {
      await apiClient.delete('/bookmarks/$id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getEntityDetail(
    String entityType,
    String entityId,
  ) async {
    // Bookmarks only ever point at resources — see the entityType filter
    // in getBookmarks above.
    try {
      final response = await apiClient.get('/resources/$entityId');
      return Right(response.data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
