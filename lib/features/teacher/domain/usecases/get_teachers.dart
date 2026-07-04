import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/teacher.dart';
import '../repositories/teacher_repository.dart';

part 'get_teachers.freezed.dart';

@freezed
abstract class GetTeachersParams with _$GetTeachersParams {
  const factory GetTeachersParams({
    required String universityId,
    required String departmentId,
    bool? isPresent,
  }) = _GetTeachersParams;
}

class GetTeachers implements UseCase<List<Teacher>, GetTeachersParams> {
  final TeacherRepository repository;

  GetTeachers(this.repository);

  @override
  Future<Either<Failure, List<Teacher>>> call(GetTeachersParams params) async {
    return await repository.getTeachers(
      universityId: params.universityId,
      departmentId: params.departmentId,
      isPresent: params.isPresent,
    );
  }
}
