import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/university.dart';
import '../repositories/university_repository.dart';

class GetUniversities implements UseCase<List<University>, NoParams> {
  final UniversityRepository repository;

  GetUniversities(this.repository);

  @override
  Future<Either<Failure, List<University>>> call(NoParams params) async {
    return await repository.getUniversities();
  }
}
