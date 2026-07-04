import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/staff.dart';
import '../repositories/staff_repository.dart';

part 'get_staff.freezed.dart';

@freezed
abstract class GetStaffParams with _$GetStaffParams {
  const factory GetStaffParams({
    required String universityId,
    required String departmentId,
  }) = _GetStaffParams;
}

class GetStaff implements UseCase<List<Staff>, GetStaffParams> {
  final StaffRepository repository;

  GetStaff(this.repository);

  @override
  Future<Either<Failure, List<Staff>>> call(GetStaffParams params) async {
    return await repository.getStaff(
      universityId: params.universityId,
      departmentId: params.departmentId,
    );
  }
}
