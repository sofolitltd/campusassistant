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
}
