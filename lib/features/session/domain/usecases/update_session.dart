import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class UpdateSession {
  final SessionRepository repository;

  UpdateSession(this.repository);

  Future<Either<Failure, Session>> call(Session session) async {
    return await repository.updateSession(session);
  }
}
