import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final ApiClient apiClient;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  final Map<String, List<Course>> _coursesCache = {};
  final Map<String, Course> _courseByCodeCache = {};

  CourseRepositoryImpl({
    required this.apiClient,
    required this.cacheManager,
    required this.connectivity,
  });

  String _buildCacheKey({
    required String universityId,
    required String departmentId,
    String? semesterId,
    String? batchId,
  }) {
    final parts = <String>[
      'uni_$universityId',
      'dept_$departmentId',
      if (semesterId != null) 'sem_$semesterId',
      if (batchId != null) 'batch_$batchId',
    ];
    return parts.join('_');
  }

  @override
  Future<Either<Failure, List<Course>>> getCourses({
    required String universityId,
    required String departmentId,
    String? semesterId,
    String? batchId,
  }) async {
    final cacheKey = _buildCacheKey(
      universityId: universityId,
      departmentId: departmentId,
      semesterId: semesterId,
      batchId: batchId,
    );

    // 0. In-memory cache (instant — no microtask delay)
    if (_coursesCache.containsKey(cacheKey)) {
      debugPrint(
        '[CourseRepo] Returning ${_coursesCache[cacheKey]!.length} courses from in-memory cache',
      );
      return Right(_coursesCache[cacheKey]!);
    }

    // 1. Try DB cache
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: 'course_$cacheKey',
      );
      if (cachedData.isNotEmpty) {
        final courses = cachedData
            .map((json) => CourseModel.fromJson(json).toEntity())
            .toList();
        _coursesCache[cacheKey] = courses;
        debugPrint('[CourseRepo] Returning ${courses.length} cached courses');
        return Right(courses);
      }
    } catch (e) {
      debugPrint('[CourseRepo] Cache read failed: $e');
    }

    // 2. Try remote if online
    if (connectivity.isConnected) {
      try {
        final queryParams = {
          'university_id': universityId,
          'department_id': departmentId,
        };
        if (semesterId != null) queryParams['level_id'] = semesterId;
        if (batchId != null) queryParams['batch_id'] = batchId;

        debugPrint('[getCourses] queryParams=$queryParams');
        final response = await apiClient.get(
          '/courses',
          queryParameters: queryParams,
        );
        final body = response.data as Map<String, dynamic>;
        final List<dynamic> data = body['data'] ?? [];
        debugPrint('[getCourses] returned ${data.length} courses');

        final courses = data
            .map((json) => CourseModel.fromJson(json).toEntity())
            .toList();

        await cacheManager.cacheList(
          entityType: 'course_$cacheKey',
          items: data.cast<Map<String, dynamic>>(),
          ttl: CacheTTL.course,
        );
        _coursesCache[cacheKey] = courses;

        return Right(courses);
      } catch (e) {
        debugPrint('[CourseRepo] Remote fetch failed: $e');
      }
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection and no cached course data available',
        ),
      );
    }

    return Left(ServerFailure('Failed to fetch courses'));
  }

  @override
  Future<Either<Failure, Course>> getCourseByCode({
    required String universityId,
    required String departmentId,
    required String courseCode,
    String? batchId,
    String? semesterId,
  }) async {
    // 0. In-memory cache (instant)
    if (_courseByCodeCache.containsKey(courseCode)) {
      debugPrint(
        '[CourseRepo] Returning course $courseCode from in-memory cache',
      );
      return Right(_courseByCodeCache[courseCode]!);
    }

    // 1. Try DB cache
    try {
      final cached = await cacheManager.getCachedSingle(
        entityType: 'course_detail',
        entityKey: courseCode,
      );
      if (cached != null) {
        final course = CourseModel.fromJson(cached).toEntity();
        _courseByCodeCache[courseCode] = course;
        debugPrint('[CourseRepo] Returning course $courseCode from DB cache');
        return Right(course);
      }
    } catch (e) {
      debugPrint('[CourseRepo] Cache read by code failed: $e');
    }

    // 2. Try remote if online
    if (connectivity.isConnected) {
      try {
        final queryParams = <String, dynamic>{
          'university_id': universityId,
          'department_id': departmentId,
          'course_code': courseCode,
        };
        if (batchId != null) queryParams['batch_id'] = batchId;
        if (semesterId != null) queryParams['level_id'] = semesterId;

        final response = await apiClient.get(
          '/courses',
          queryParameters: queryParams,
        );
        final body = response.data as Map<String, dynamic>;
        final List<dynamic> data = body['data'] ?? [];
        if (data.isEmpty) {
          return Left(ServerFailure('Course not found'));
        }

        final course = CourseModel.fromJson(data.first).toEntity();
        _courseByCodeCache[courseCode] = course;

        for (final json in data) {
          await cacheManager.cacheSingle(
            entityType: 'course_detail',
            entityKey: CourseModel.fromJson(json).courseCode,
            data: json,
            ttl: CacheTTL.course,
          );
        }

        return Right(course);
      } catch (e) {
        debugPrint('[CourseRepo] Remote fetch by code failed: $e');
      }
    }

    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection and no cached course data available',
        ),
      );
    }

    return Left(ServerFailure('Course not found'));
  }

  @override
  Future<Either<Failure, Course>> createCourse(Course course) async {
    try {
      final model = CourseModel.fromEntity(course);
      final response = await apiClient.post('/courses', data: model.toJson());
      return Right(CourseModel.fromJson(response.data).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Course>> updateCourse(Course course) async {
    try {
      final model = CourseModel.fromEntity(course);
      final response = await apiClient.put(
        '/courses/${course.id}',
        data: model.toJson(),
      );
      return Right(CourseModel.fromJson(response.data).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCourse(String id) async {
    try {
      await apiClient.delete('/courses/$id');
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
