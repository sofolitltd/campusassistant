import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/routine.dart';
import '../../domain/repositories/routine_repository.dart';
import '../models/routine_model.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final ApiClient apiClient;

  RoutineRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<Routine>>> getRoutines({
    required String universityId,
    required String departmentId,
  }) async {
    try {
      final response = await apiClient.get(
        '/routines',
        queryParameters: {
          'university_id': universityId,
          'department_id': departmentId,
        },
      );
      final envelope = response.data as Map<String, dynamic>;
      final List<dynamic> data = envelope['data'] ?? [];
      final routines = data
          .map((json) => RoutineModel.fromJson(json as Map<String, dynamic>).toEntity())
          .toList();
      return Right(routines);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRoutine(String id) async {
    try {
      await apiClient.delete('/routines/$id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
