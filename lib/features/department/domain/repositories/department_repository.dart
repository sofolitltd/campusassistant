import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/department.dart';

abstract class DepartmentRepository {
  Future<Either<Failure, List<Department>>> getDepartments({
    required String universityId,
  });
  Future<Either<Failure, Department>> createDepartment(Department department);
  Future<Either<Failure, Department>> updateDepartment(Department department);
  Future<Either<Failure, void>> deleteDepartment(String id);
  Future<Either<Failure, String>> uploadLogo(String filePath);
}
