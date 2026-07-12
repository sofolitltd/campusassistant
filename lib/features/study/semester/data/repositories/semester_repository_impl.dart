import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/cache/cache_manager.dart';
import '../../../../../core/cache/connectivity_service.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/semester.dart';
import '../../domain/repositories/semester_repository.dart';
import '../models/semester_model.dart';

class SemesterRepositoryImpl implements SemesterRepository {
  final ApiClient apiClient;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  SemesterRepositoryImpl({
    required this.apiClient,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Semester>>> getSemesters({
    required String universityId,
    required String departmentId,
    String? batch,
  }) async {
    final cacheKey = 'semester_uni_${universityId}_dept_${departmentId}';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final queryParams = {
          'university_id': universityId,
          'department_id': departmentId,
        };
        if (batch != null) queryParams['batch'] = batch;

        final response = await apiClient.get(
          ApiEndpoints.levels,
          queryParameters: queryParams,
        );

        final List<dynamic> rawData = response.data['data'] ?? [];
        final semesters = rawData
            .map((json) => SemesterModel.fromJson(json).toEntity())
            .toList();

        // Cache the result
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: rawData.cast<Map<String, dynamic>>(),
          ttl: CacheTTL.semester,
        );

        return Right(semesters);
      } catch (e) {
        debugPrint('[SemesterRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: cacheKey,
      );
      if (cachedData.isNotEmpty) {
        final semesters = cachedData
            .map((json) => SemesterModel.fromJson(json).toEntity())
            .toList();
        debugPrint('[SemesterRepo] Returning ${semesters.length} cached semesters');
        return Right(semesters);
      }
    } catch (e) {
      debugPrint('[SemesterRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached semester data available',
      ));
    }

    return Left(ServerFailure('Failed to fetch semesters'));
  }

  @override
  Future<Either<Failure, Semester>> createSemester(Semester semester) async {
    try {
      final model = SemesterModel.fromEntity(semester);

      final response = await apiClient.post(ApiEndpoints.levels, data: model.toJson());
      return Right(SemesterModel.fromJson(response.data).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Semester>> updateSemester(Semester semester) async {
    try {
      final model = SemesterModel.fromEntity(semester);

      final response = await apiClient.put(
        '${ApiEndpoints.levels}/${semester.id}',
        data: model.toJson(),
      );
      return Right(SemesterModel.fromJson(response.data).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSemester(String id) async {
    try {
      await apiClient.delete('${ApiEndpoints.levels}/$id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
