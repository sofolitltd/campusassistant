import 'package:dartz/dartz.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/cache/offline_first_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl with OfflineFirstMixin implements CourseRepository {
  final ApiClient apiClient;
  @override
  final CacheManager cacheManager;
  @override
  final ConnectivityService connectivity;

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

  Future<List<Map<String, dynamic>>> _fetchCourses(
    Map<String, dynamic> queryParams,
  ) async {
    final response = await apiClient.get(
      '/courses',
      queryParameters: queryParams,
    );
    final body = response.data as Map<String, dynamic>;
    final List<dynamic> data = body['data'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Stream<List<Course>> watchCourses({
    required String universityId,
    required String departmentId,
    String? semesterId,
    String? batchId,
  }) {
    final cacheKey = _buildCacheKey(
      universityId: universityId,
      departmentId: departmentId,
      semesterId: semesterId,
      batchId: batchId,
    );
    return watchListWithCache(
      entityType: 'course_$cacheKey',
      cacheTTL: CacheTTL.course,
      fetchFromRemote: () => _fetchCourses({
        'university_id': universityId,
        'department_id': departmentId,
        'level_id': ?semesterId,
        'batch_id': ?batchId,
      }),
      fromJson: (json) => CourseModel.fromJson(json).toEntity(),
    );
  }

  @override
  Stream<Course?> watchCourseByCode({
    required String universityId,
    required String departmentId,
    required String courseCode,
    String? batchId,
    String? semesterId,
  }) {
    return watchSingleWithCache(
      entityType: 'course_detail',
      // Course codes repeat across departments, so scope the key.
      entityKey: '${universityId}_${departmentId}_$courseCode',
      cacheTTL: CacheTTL.course,
      fetchFromRemote: () async {
        final data = await _fetchCourses({
          'university_id': universityId,
          'department_id': departmentId,
          'course_code': courseCode,
          'batch_id': ?batchId,
          'level_id': ?semesterId,
        });
        return data.firstOrNull;
      },
      fromJson: (json) => CourseModel.fromJson(json).toEntity(),
    );
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
