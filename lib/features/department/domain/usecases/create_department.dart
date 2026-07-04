import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/department.dart';
import '../repositories/department_repository.dart';

class CreateDepartment implements UseCase<Department, Department> {
  final DepartmentRepository repository;

  CreateDepartment(this.repository);

  @override
  Future<Either<Failure, Department>> call(Department department) async {
    return await repository.createDepartment(department);
  }
}
