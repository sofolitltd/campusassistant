import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/staff.dart';
import '../../domain/repositories/staff_repository.dart';
import '../datasources/staff_remote_data_source.dart';
import '../models/staff_model.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  StaffRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  String _cacheKey(String universityId, String departmentId) =>
      'staff_uni_${universityId}_dept_$departmentId';

  @override
  Future<Either<Failure, List<Staff>>> getStaff({
    required String universityId,
    required String departmentId,
  }) async {
    final cacheKey = _cacheKey(universityId, departmentId);

    // 1. Try remote if online, then cache the result.
    if (connectivity.isConnected) {
      try {
        final result = await remoteDataSource.getStaff(
          universityId: universityId,
          departmentId: departmentId,
        );
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: result.map((m) => m.toJson()).toList(),
          ttl: CacheTTL.department,
        );
        return Right(result.map((m) => m.toEntity()).toList());
      } catch (e) {
        debugPrint('[StaffRepo] Remote fetch failed: $e');
      }
    }

    // 2. Fall back to cache.
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: cacheKey,
      );
      if (cachedData.isNotEmpty) {
        return Right(
          cachedData.map((json) => StaffModel.fromJson(json).toEntity()).toList(),
        );
      }
    } catch (e) {
      debugPrint('[StaffRepo] Cache read failed: $e');
    }

    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure('No internet connection and no cached staff available'),
      );
    }

    return Left(ServerFailure('Failed to fetch staff'));
  }

  @override
  Future<Either<Failure, int>> getStaffCount({
    required String universityId,
    required String departmentId,
  }) async {
    if (connectivity.isConnected) {
      try {
        final count = await remoteDataSource.getStaffCount(
          universityId: universityId,
          departmentId: departmentId,
        );
        return Right(count);
      } catch (e) {
        debugPrint('[StaffRepo] Remote count failed: $e');
      }
    }

    // Offline / failure fallback: count whatever list is cached.
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: _cacheKey(universityId, departmentId),
      );
      return Right(cachedData.length);
    } catch (e) {
      debugPrint('[StaffRepo] Cached count read failed: $e');
    }

    return Left(ServerFailure('Failed to fetch staff count'));
  }

  @override
  Future<Either<Failure, Staff>> getStaffById({
    required String universityId,
    required String departmentId,
    required String staffId,
  }) async {
    try {
      final result = await remoteDataSource.getStaffById(
        universityId: universityId,
        departmentId: departmentId,
        staffId: staffId,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Staff>> createStaff(Staff staff) async {
    try {
      final model = StaffModel.fromEntity(staff);
      final result = await remoteDataSource.createStaff(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Staff>> updateStaff(Staff staff) async {
    try {
      final model = StaffModel.fromEntity(staff);
      final result = await remoteDataSource.updateStaff(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStaff(String id) async {
    try {
      await remoteDataSource.deleteStaff(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
