import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/department.dart';
import '../../domain/repositories/department_repository.dart';
import '../datasources/department_remote_data_source.dart';
import '../models/department_model.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  DepartmentRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Department>>> getDepartments({
    required String universityId,
  }) async {
    final cacheKey = 'departments_$universityId';

    // Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteDepartments = await remoteDataSource.getDepartments(
          universityId: universityId,
        );
        final entities = remoteDepartments.map((m) => m.toEntity()).toList();

        // Cache the result
        final cacheItems = remoteDepartments.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: cacheItems,
          ttl: CacheTTL.department,
        );

        return Right(entities);
      } catch (e) {
        debugPrint('[DepartmentRepo] Remote fetch failed: $e');
        // Fall through to cache
      }
    }

    // Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: cacheKey,
      );
      if (cachedData.isNotEmpty) {
        final departments = cachedData
            .map((json) => DepartmentModel.fromJson(json).toEntity())
            .toList();
        debugPrint('[DepartmentRepo] Returning ${departments.length} cached departments');
        return Right(departments);
      }
    } catch (e) {
      debugPrint('[DepartmentRepo] Cache read failed: $e');
    }

    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached department data available',
      ));
    }

    return Left(ServerFailure('Failed to fetch departments'));
  }

  @override
  Future<Either<Failure, Department>> createDepartment(
    Department department,
  ) async {
    try {
      final model = DepartmentModel.fromEntity(department);
      final result = await remoteDataSource.createDepartment(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Department>> updateDepartment(
    Department department,
  ) async {
    try {
      final model = DepartmentModel.fromEntity(department);
      final result = await remoteDataSource.updateDepartment(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDepartment(String id) async {
    try {
      await remoteDataSource.deleteDepartment(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLogo(String filePath) async {
    try {
      final url = await remoteDataSource.uploadLogo(filePath);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
