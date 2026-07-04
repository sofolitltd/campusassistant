import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/department.dart';
import '../../domain/repositories/department_repository.dart';
import '../datasources/department_remote_data_source.dart';
import '../models/department_model.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentRemoteDataSource remoteDataSource;

  DepartmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Department>>> getDepartments({
    required String universityId,
  }) async {
    try {
      final remoteDepartments = await remoteDataSource.getDepartments(
        universityId: universityId,
      );
      return Right(remoteDepartments.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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
