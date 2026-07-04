import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/department_repository.dart';

class UploadDepartmentLogo implements UseCase<String, String> {
  final DepartmentRepository repository;

  UploadDepartmentLogo(this.repository);

  @override
  Future<Either<Failure, String>> call(String filePath) async {
    return await repository.uploadLogo(filePath);
  }
}
