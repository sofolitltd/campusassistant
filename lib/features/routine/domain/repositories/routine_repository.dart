import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/routine.dart';

abstract class RoutineRepository {
  Future<Either<Failure, List<Routine>>> getRoutines({
    required String universityId,
    required String departmentId,
  });

  Future<Either<Failure, void>> deleteRoutine(String id);
}
