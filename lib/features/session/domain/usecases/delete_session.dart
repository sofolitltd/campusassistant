import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/session_repository.dart';

class DeleteSession {
  final SessionRepository repository;

  DeleteSession(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteSession(id);
  }
}
