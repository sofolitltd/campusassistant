import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../datasources/teacher_remote_data_source.dart';
import '../models/teacher_model.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  TeacherRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Teacher>>> getTeachers({
    required String universityId,
    required String departmentId,
    bool? isPresent,
  }) async {
    final cacheKey = 'uni_${universityId}_dept_$departmentId';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteTeachers = await remoteDataSource.getTeachers(
          universityId: universityId,
          departmentId: departmentId,
          isPresent: isPresent,
        );
        final entities = remoteTeachers.map((m) => m.toEntity()).toList();

        // Cache the result
        final cacheItems = remoteTeachers.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: 'teacher_$cacheKey',
          items: cacheItems,
          ttl: CacheTTL.teacher,
        );

        return Right(entities);
      } catch (e) {
        debugPrint('[TeacherRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: 'teacher_$cacheKey',
      );

      if (cachedData.isNotEmpty) {
        final teachers = cachedData
            .map((json) => TeacherModel.fromJson(json).toEntity())
            .toList();
        debugPrint(
          '[TeacherRepo] Returning ${teachers.length} cached teachers',
        );
        return Right(teachers);
      }
    } catch (e) {
      debugPrint('[TeacherRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection and no cached teachers available',
        ),
      );
    }

    return Left(ServerFailure('Failed to fetch teachers'));
  }

  @override
  Future<Either<Failure, Teacher>> getTeacherById({
    required String universityId,
    required String departmentId,
    required String teacherId,
  }) async {
    // Try remote first
    if (connectivity.isConnected) {
      try {
        final remoteTeacher = await remoteDataSource.getTeacherById(
          universityId: universityId,
          departmentId: departmentId,
          teacherId: teacherId,
        );

        // Cache this specific teacher
        await cacheManager.cacheSingle(
          entityType: 'teacher_detail',
          entityKey: teacherId,
          data: remoteTeacher.toJson(),
          ttl: CacheTTL.teacher,
        );

        return Right(remoteTeacher.toEntity());
      } catch (e) {
        debugPrint('[TeacherRepo] Remote fetch failed for teacherId: $e');
      }
    }

    // Try cache
    try {
      final cached = await cacheManager.getCachedSingle(
        entityType: 'teacher_detail',
        entityKey: teacherId,
      );
      if (cached != null) {
        return Right(TeacherModel.fromJson(cached).toEntity());
      }
    } catch (e) {
      debugPrint('[TeacherRepo] Cache read failed for teacherId: $e');
    }

    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection and no cached teacher data available',
        ),
      );
    }

    return Left(ServerFailure('Failed to fetch teacher'));
  }

  @override
  Future<Either<Failure, Teacher>> createTeacher(Teacher teacher) async {
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure('Internet connection required to create teacher'),
      );
    }
    try {
      final teacherModel = TeacherModel.fromEntity(teacher);
      final result = await remoteDataSource.createTeacher(teacherModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Teacher>> updateTeacher(Teacher teacher) async {
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure('Internet connection required to update teacher'),
      );
    }
    try {
      final teacherModel = TeacherModel.fromEntity(teacher);
      final result = await remoteDataSource.updateTeacher(teacherModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeacher(String teacherId) async {
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure('Internet connection required to delete teacher'),
      );
    }
    try {
      await remoteDataSource.deleteTeacher(teacherId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
