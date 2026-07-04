import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/department.dart';
import '../repositories/department_repository.dart';

class GetDepartmentsParams {
  final String universityId;
  const GetDepartmentsParams({required this.universityId});
}

class GetDepartments
    implements UseCase<List<Department>, GetDepartmentsParams> {
  final DepartmentRepository repository;

  GetDepartments(this.repository);

  @override
  Future<Either<Failure, List<Department>>> call(
    GetDepartmentsParams params,
  ) async {
    return await repository.getDepartments(universityId: params.universityId);
  }
}
