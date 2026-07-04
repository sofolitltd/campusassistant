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
    String? courseYear,
    String? batchId,
  }) async {
    try {
      final queryParams = {
        'university_id': universityId,
        'department_id': departmentId,
      };
      if (courseYear != null) queryParams['semester_id'] = courseYear;
      if (batchId != null) queryParams['batch_id'] = batchId;

      final response = await apiClient.get(
        '/courses',
        queryParameters: queryParams,
      );
      final body = response.data as Map<String, dynamic>;
      final List<dynamic> data = body['data'] ?? [];
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
  }) async {
    try {
      final queryParams = {
        'university_id': universityId,
        'department_id': departmentId,
        'course_code': courseCode,
      };
      final response = await apiClient.get(
        '/courses',
        queryParameters: queryParams,
      );
      final body = response.data as Map<String, dynamic>;
      final List<dynamic> data = body['data'] ?? [];
      if (data.isEmpty) {
        return Left(ServerFailure('Course not found'));
      }
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
