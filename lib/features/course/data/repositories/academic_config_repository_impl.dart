import 'package:dartz/dartz.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/failures.dart';
import '../models/course_category_model.dart';
import '../models/course_prefix_model.dart';
import '../../domain/entities/course_category.dart';
import '../../domain/entities/course_prefix.dart';
import '../../domain/repositories/academic_config_repository.dart';

class AcademicConfigRepositoryImpl implements AcademicConfigRepository {
  final ApiClient apiClient;

  AcademicConfigRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<CourseCategory>>> getCategories({
    required String universityId,
    required String departmentId,
  }) async {
    try {
      final response = await apiClient.get(
        '/course-categories',
        queryParameters: {
          'university_id': universityId,
          'department_id': departmentId,
        },
      );
      final List<dynamic> rawData = response.data['data'] ?? [];
      final categories = rawData
          .map((e) => CourseCategoryModel.fromJson(e).toEntity())
          .toList();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseCategory>> createCategory(
    CourseCategory category,
  ) async {
    try {
      final model = CourseCategoryModel.fromEntity(category);
      final response = await apiClient.post(
        '/course-categories',
        data: model.toJson(),
      );
      return Right(CourseCategoryModel.fromJson(response.data).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    try {
      await apiClient.delete('/course-categories/$id');
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CoursePrefix>>> getPrefixes({
    required String universityId,
    required String departmentId,
  }) async {
    try {
      final response = await apiClient.get(
        '/course-prefixes',
        queryParameters: {
          'university_id': universityId,
          'department_id': departmentId,
        },
      );
      final List<dynamic> rawData = response.data['data'] ?? [];
      final prefixes = rawData
          .map((e) => CoursePrefixModel.fromJson(e).toEntity())
          .toList();
      return Right(prefixes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoursePrefix>> createPrefix(
    CoursePrefix prefix,
  ) async {
    try {
      final model = CoursePrefixModel.fromEntity(prefix);
      final response = await apiClient.post(
        '/course-prefixes',
        data: model.toJson(),
      );
      return Right(CoursePrefixModel.fromJson(response.data).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePrefix(String id) async {
    try {
      await apiClient.delete('/course-prefixes/$id');
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
