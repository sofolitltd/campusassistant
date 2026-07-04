import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/university.dart';
import '../entities/hall.dart';

abstract class UniversityRepository {
  Future<Either<Failure, List<University>>> getUniversities();
  Future<Either<Failure, University>> createUniversity(University university);
  Future<Either<Failure, University>> updateUniversity(University university);
  Future<Either<Failure, void>> deleteUniversity(String id);
  Future<Either<Failure, String>> uploadLogo(String filePath, {String? folder});
  Future<Either<Failure, String>> uploadLogoBytes(
    List<int> bytes,
    String fileName, {
    String? folder,
  });
  Future<Either<Failure, List<Hall>>> getHalls(String universityId);
  Future<Either<Failure, Hall>> createHall(Hall hall);
  Future<Either<Failure, Hall>> updateHall(Hall hall);
  Future<Either<Failure, void>> deleteHall(String id);
}
