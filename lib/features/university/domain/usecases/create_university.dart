import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/university.dart';
import '../repositories/university_repository.dart';

class CreateUniversity implements UseCase<University, University> {
  final UniversityRepository repository;

  CreateUniversity(this.repository);

  @override
  Future<Either<Failure, University>> call(University university) async {
    return await repository.createUniversity(university);
  }
}
