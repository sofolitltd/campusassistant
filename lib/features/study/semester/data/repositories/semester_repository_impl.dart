import 'package:dartz/dartz.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/semester.dart';
import '../../domain/repositories/semester_repository.dart';
import '../models/semester_model.dart';

class SemesterRepositoryImpl implements SemesterRepository {
  final ApiClient apiClient;

  SemesterRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<Semester>>> getSemesters({
    required String universityId,
    required String departmentId,
    String? batch,
  }) async {
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
      return Right(semesters);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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
