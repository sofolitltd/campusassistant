import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/club.dart';

abstract class ClubRepository {
  Future<Either<Failure, List<Club>>> getClubs({
    required String universityId,
    String? departmentId,
    required String type,
  });
}
