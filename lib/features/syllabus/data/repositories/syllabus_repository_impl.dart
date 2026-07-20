import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/syllabus_repository.dart';
import '../models/syllabus_model.dart';

class SyllabusRepositoryImpl implements SyllabusRepository {
  final ApiClient apiClient;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  SyllabusRepositoryImpl({
    required this.apiClient,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, PaginatedSyllabi>> getSyllabi({
    required String universityId,
    required String departmentId,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final cacheKey = 'syllabus_uni_${universityId}_dept_$departmentId';
    final totalCacheKey = 'syllabus_total_${universityId}_$departmentId';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final Map<String, dynamic> params = {
          'type': 'syllabus',
          'university_id': universityId,
          'department_id': departmentId,
        };
        if (search != null && search.isNotEmpty) {
          params['search'] = search;
        }
        if (limit != null) {
          params['limit'] = limit;
        } else {
          params['limit'] = 20;
        }
        if (offset != null) {
          params['offset'] = offset;
        }

        final response = await apiClient.get(
          '/resources',
          queryParameters: params,
        );
        final envelope = response.data as Map<String, dynamic>;
        final List<dynamic> data = envelope['data'] ?? [];
        final int count = envelope['count'] ?? 0;
        final list = data
            .map(
              (json) => SyllabusModel.fromJson(
                json as Map<String, dynamic>,
              ).toEntity(),
            )
            .toList();

        // Cache first page list
        if (offset == null || offset == 0) {
          await cacheManager.cacheList(
            entityType: cacheKey,
            items: data.cast<Map<String, dynamic>>(),
            ttl: CacheTTL.syllabus,
          );
          await cacheManager.cacheSingle(
            entityType: totalCacheKey,
            entityKey: 'total',
            data: {'total': count},
            ttl: CacheTTL.syllabus,
          );
        }

        return Right(PaginatedSyllabi(syllabi: list, total: count));
      } catch (e) {
        debugPrint('[SyllabusRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data (always, regardless of offset/search)
    try {
      final cachedData = await cacheManager.getCachedList(entityType: cacheKey);
      if (cachedData.isNotEmpty) {
        final syllabi = cachedData
            .map((json) => SyllabusModel.fromJson(json).toEntity())
            .toList();

        int total = syllabi.length;
        final totalEntry = await cacheManager.getCachedSingle(
          entityType: totalCacheKey,
          entityKey: 'total',
        );
        if (totalEntry != null && totalEntry['total'] is int) {
          total = totalEntry['total'] as int;
        }

        debugPrint('[SyllabusRepo] Returning ${syllabi.length} cached syllabi');
        return Right(PaginatedSyllabi(syllabi: syllabi, total: total));
      }
    } catch (e) {
      debugPrint('[SyllabusRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return Left(
        NetworkFailure(
          'No internet connection and no cached syllabus data available',
        ),
      );
    }

    return Left(ServerFailure('Failed to fetch syllabi'));
  }
}
