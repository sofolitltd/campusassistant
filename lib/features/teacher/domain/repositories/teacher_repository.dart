import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/teacher.dart';

abstract class TeacherRepository {
  Future<Either<Failure, List<Teacher>>> getTeachers({
    required String universityId,
    required String departmentId,
    bool? isPresent,
  });

  /// Offline-first variant of [getTeachers]: emits cached teachers
  /// immediately if present, then emits the fresh network result once it
  /// arrives (or an error/empty result if offline with no cache).
  Stream<Either<Failure, List<Teacher>>> watchTeachers({
    required String universityId,
    required String departmentId,
    bool? isPresent,
  });

  Future<Either<Failure, int>> getTeacherCount({
    required String universityId,
    required String departmentId,
  });

  Future<Either<Failure, Teacher>> getTeacherById({
    required String universityId,
    required String departmentId,
    required String teacherId,
  });

  Future<Either<Failure, Teacher>> createTeacher(Teacher teacher);
  Future<Either<Failure, Teacher>> updateTeacher(Teacher teacher);
  Future<Either<Failure, void>> deleteTeacher(String teacherId);

  /// Checks whether [code] matches an unclaimed Teacher profile (set up by
  /// an admin) before the user attempts to claim it.
  Future<Either<Failure, Teacher>> verifyCode(String code);

  /// Links the just-registered [userId] to the Teacher profile matching
  /// [code], completing account setup for app login.
  Future<Either<Failure, Teacher>> claimProfile({
    required String code,
    required String userId,
    String? phone,
  });
}
