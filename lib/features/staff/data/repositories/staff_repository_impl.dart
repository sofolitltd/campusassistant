import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/staff.dart';
import '../../domain/repositories/staff_repository.dart';
import '../datasources/staff_remote_data_source.dart';
import '../models/staff_model.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource remoteDataSource;

  StaffRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Staff>>> getStaff({
    required String universityId,
    required String departmentId,
  }) async {
    try {
      final result = await remoteDataSource.getStaff(
        universityId: universityId,
        departmentId: departmentId,
      );
      return Right(result.map((m) => m.toEntity()).toList());
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
