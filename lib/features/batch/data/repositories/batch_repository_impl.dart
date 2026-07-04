import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../datasources/batch_remote_data_source.dart';
import '../../domain/entities/batch.dart';
import '../models/batch_model.dart';
import '../../domain/repositories/batch_repository.dart';

class BatchRepositoryImpl implements BatchRepository {
  final BatchRemoteDataSource remoteDataSource;

  BatchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Batch>>> getBatches({
    required String departmentId,
  }) async {
    try {
      final result = await remoteDataSource.getBatches(
        departmentId: departmentId,
      );
      return Right(result.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Batch>> createBatch(Batch batch) async {
    try {
      final model = BatchModel.fromEntity(batch);
      final result = await remoteDataSource.createBatch(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Batch>> updateBatch(Batch batch) async {
    try {
      final model = BatchModel.fromEntity(batch);
      final result = await remoteDataSource.updateBatch(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBatch(String id) async {
    try {
      await remoteDataSource.deleteBatch(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
