import 'package:flutter/foundation.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/notice_remote_data_source.dart';
import '../../domain/repositories/notice_repository.dart';
import '../models/notice_comment_model.dart';
import '../models/notice_model.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  NoticeRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<List<NoticeModel>> getNotices({
    required String universityId,
    required String departmentId,
  }) async {
    final cacheKey = 'notice_uni_${universityId}_dept_$departmentId';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        var notices = await remoteDataSource.getNotices(
          universityId: universityId,
          departmentId: departmentId,
        );

        // Merge in the current user's like state (best-effort).
        try {
          final likedIds = await remoteDataSource.getLikedNoticeIds(
            departmentId: departmentId,
          );
          final likedSet = likedIds.toSet();
          notices = notices
              .map((n) => n.copyWith(isLiked: likedSet.contains(n.id)))
              .toList();
        } catch (e) {
          debugPrint('[NoticeRepo] Failed to fetch liked state: $e');
        }

        // Cache the result
        final cacheItems = notices.map((n) => n.toJson()).toList();
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: cacheItems,
          ttl: CacheTTL.notice,
        );

        return notices;
      } catch (e) {
        debugPrint('[NoticeRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(entityType: cacheKey);
      if (cachedData.isNotEmpty) {
        final notices = cachedData
            .map((json) => NoticeModel.fromJson(json))
            .toList();
        debugPrint('[NoticeRepo] Returning ${notices.length} cached notices');
        return notices;
      }
    } catch (e) {
      debugPrint('[NoticeRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      throw NetworkFailure(
        'No internet connection and no cached notice data available',
      );
    }

    throw ServerFailure('Failed to fetch notices');
  }

  @override
  Future<List<String>> getLikedNoticeIds({required String departmentId}) {
    return remoteDataSource.getLikedNoticeIds(departmentId: departmentId);
  }

  @override
  Future<void> likeNotice(String id) {
    if (!connectivity.isConnected) {
      throw NetworkFailure('Internet connection required');
    }
    return remoteDataSource.likeNotice(id);
  }

  @override
  Future<void> unlikeNotice(String id) {
    if (!connectivity.isConnected) {
      throw NetworkFailure('Internet connection required');
    }
    return remoteDataSource.unlikeNotice(id);
  }

  @override
  Future<void> viewNotice(String id) {
    if (!connectivity.isConnected) return Future.value();
    return remoteDataSource.viewNotice(id);
  }

  @override
  Future<List<NoticeCommentModel>> getComments(String noticeId) {
    if (!connectivity.isConnected) return Future.value([]);
    return remoteDataSource.getComments(noticeId);
  }

  @override
  Future<NoticeCommentModel> addComment(String noticeId, String content) {
    if (!connectivity.isConnected) {
      throw NetworkFailure('Internet connection required to add a comment');
    }
    return remoteDataSource.addComment(noticeId, content);
  }

  @override
  Future<void> deleteComment(String id) {
    if (!connectivity.isConnected) {
      throw NetworkFailure('Internet connection required');
    }
    return remoteDataSource.deleteComment(id);
  }
}
