import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/cache/offline_first_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/routine.dart';
import '../../domain/repositories/routine_repository.dart';
import '../models/routine_model.dart';

class RoutineRepositoryImpl
    with OfflineFirstMixin
    implements RoutineRepository {
  final ApiClient apiClient;
  @override
  final CacheManager cacheManager;
  @override
  final ConnectivityService connectivity;

  RoutineRepositoryImpl({
    required this.apiClient,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Routine>>> getRoutines({
    required String universityId,
    required String departmentId,
  }) async {
    final cacheKey = 'uni_${universityId}_dept_$departmentId';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final response = await apiClient.get(
          '/routines',
          queryParameters: {
            'university_id': universityId,
            'department_id': departmentId,
          },
        );
        final envelope = response.data as Map<String, dynamic>;
        final List<dynamic> data = envelope['data'] ?? [];
        final routines = data
            .map(
              (json) => RoutineModel.fromJson(
                json as Map<String, dynamic>,
              ).toEntity(),
            )
            .toList();

        // Cache the result
        final cacheItems = data.cast<Map<String, dynamic>>();
        await cacheManager.cacheList(
          entityType: 'routine_$cacheKey',
          items: cacheItems,
          ttl: CacheTTL.routine,
        );

        return Right(routines);
      } catch (e) {
        debugPrint('[RoutineRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: 'routine_$cacheKey',
      );

      if (cachedData.isNotEmpty) {
        final routines = cachedData
            .map((json) => RoutineModel.fromJson(json).toEntity())
            .toList();
        debugPrint(
          '[RoutineRepo] Returning ${routines.length} cached routines',
        );
        return Right(routines);
      }
    } catch (e) {
      debugPrint('[RoutineRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection and no cached routines available',
        ),
      );
    }

    return Left(ServerFailure('Failed to fetch routines'));
  }

  @override
  Future<Either<Failure, void>> deleteRoutine(String id) async {
    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        await apiClient.delete('/routines/$id');
        return const Right(null);
      } catch (e) {
        debugPrint('[RoutineRepo] Remote delete failed: $e');
      }
    }

    return Left(
      NetworkFailure('Delete operation requires internet connection'),
    );
  }
}
