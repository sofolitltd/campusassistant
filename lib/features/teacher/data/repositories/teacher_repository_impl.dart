import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../datasources/teacher_remote_data_source.dart';
import '../models/teacher_model.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;

  TeacherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Teacher>>> getTeachers({
    required String universityId,
    required String departmentId,
    bool? isPresent,
  }) async {
    try {
      final remoteTeachers = await remoteDataSource.getTeachers(
        universityId: universityId,
        departmentId: departmentId,
        isPresent: isPresent,
      );
      return Right(remoteTeachers.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Teacher>> getTeacherById({
    required String universityId,
    required String departmentId,
    required String teacherId,
  }) async {
    try {
      final remoteTeacher = await remoteDataSource.getTeacherById(
        universityId: universityId,
        departmentId: departmentId,
        teacherId: teacherId,
      );
      return Right(remoteTeacher.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Teacher>> createTeacher(Teacher teacher) async {
    try {
      final teacherModel = TeacherModel.fromEntity(teacher);
      final result = await remoteDataSource.createTeacher(teacherModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Teacher>> updateTeacher(Teacher teacher) async {
    try {
      final teacherModel = TeacherModel.fromEntity(teacher);
      final result = await remoteDataSource.updateTeacher(teacherModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeacher(String teacherId) async {
    try {
      await remoteDataSource.deleteTeacher(teacherId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
