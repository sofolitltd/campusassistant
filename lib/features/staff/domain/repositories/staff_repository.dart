import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/staff.dart';

abstract class StaffRepository {
  Future<Either<Failure, List<Staff>>> getStaff({
    required String universityId,
    required String departmentId,
  });

  Future<Either<Failure, int>> getStaffCount({
    required String universityId,
    required String departmentId,
  });

  Future<Either<Failure, Staff>> getStaffById({
    required String universityId,
    required String departmentId,
    required String staffId,
  });

  Future<Either<Failure, Staff>> createStaff(Staff staff);
  Future<Either<Failure, Staff>> updateStaff(Staff staff);
  Future<Either<Failure, void>> deleteStaff(String id);

  /// Checks whether [code] matches an unclaimed Staff profile (set up by an
  /// admin) before the user attempts to claim it.
  Future<Either<Failure, Staff>> verifyCode(String code);

  /// Links the just-registered [userId] to the Staff profile matching
  /// [code], completing account setup for app login.
  Future<Either<Failure, Staff>> claimProfile({
    required String code,
    required String userId,
    String? mobile,
  });
}
