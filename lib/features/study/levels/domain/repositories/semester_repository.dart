import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/semester.dart';

abstract class SemesterRepository {
  Future<Either<Failure, List<Semester>>> getSemesters({
    required String universityId,
    required String departmentId,
    String? batch,
  });

  Future<Either<Failure, Semester>> createSemester(Semester semester);
  Future<Either<Failure, Semester>> updateSemester(Semester semester);
  Future<Either<Failure, void>> deleteSemester(String id);
}
