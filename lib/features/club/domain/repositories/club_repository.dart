import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/club.dart';

abstract class ClubRepository {
  Future<Either<Failure, List<Club>>> getClubs({
    required String universityId,
    String? departmentId,
    required String type,
  });
  Future<Either<Failure, void>> followClub(String clubId);
  Future<Either<Failure, void>> unfollowClub(String clubId);
  // Join/leave the formal Members roster — independent of Follow.
  Future<Either<Failure, void>> joinClub(String clubId);
  Future<Either<Failure, void>> leaveClub(String clubId);
  Future<Either<Failure, Club>> suggestClub(Club club);
}
