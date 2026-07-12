import 'package:flutter/foundation.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/notice_remote_data_source.dart';
import '../../domain/repositories/notice_repository.dart';
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
    final cacheKey = 'notice_uni_${universityId}_dept_${departmentId}';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final notices = await remoteDataSource.getNotices(
          universityId: universityId,
          departmentId: departmentId,
        );

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
      final cachedData = await cacheManager.getCachedList(
        entityType: cacheKey,
      );
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
}
