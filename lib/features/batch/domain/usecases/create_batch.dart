import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/batch.dart';
import '../repositories/batch_repository.dart';

class CreateBatch implements UseCase<Batch, Batch> {
  final BatchRepository repository;

  CreateBatch(this.repository);

  @override
  Future<Either<Failure, Batch>> call(Batch batch) async {
    return await repository.createBatch(batch);
  }
}
