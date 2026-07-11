import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final ApiClient apiClient;

  CourseRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<Course>>> getCourses({
    required String universityId,
    required String departmentId,
    String? semesterId,
    String? batchId,
  }) async {
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
      return Right(data.map((json) => CourseModel.fromJson(json).toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Course>> getCourseByCode({
    required String universityId,
    required String departmentId,
    required String courseCode,
    String? batchId,
    String? semesterId,
  }) async {
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
      // When filters are applied, the first match is the correct one
      return Right(CourseModel.fromJson(data.first).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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
