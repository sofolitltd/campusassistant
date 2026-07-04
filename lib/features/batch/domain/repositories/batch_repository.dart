import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/batch.dart';

abstract class BatchRepository {
  Future<Either<Failure, List<Batch>>> getBatches({
    required String departmentId,
  });
  Future<Either<Failure, Batch>> createBatch(Batch batch);
  Future<Either<Failure, Batch>> updateBatch(Batch batch);
  Future<Either<Failure, void>> deleteBatch(String id);
}
