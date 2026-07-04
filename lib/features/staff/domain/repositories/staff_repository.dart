import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/staff.dart';

abstract class StaffRepository {
  Future<Either<Failure, List<Staff>>> getStaff({
    required String universityId,
    required String departmentId,
  });

  Future<Either<Failure, Staff>> createStaff(Staff staff);
  Future<Either<Failure, Staff>> updateStaff(Staff staff);
  Future<Either<Failure, void>> deleteStaff(String id);
}
