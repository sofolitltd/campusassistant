import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class CreateSession implements UseCase<Session, Session> {
  final SessionRepository repository;

  CreateSession(this.repository);

  @override
  Future<Either<Failure, Session>> call(Session session) async {
    return await repository.createSession(session);
  }
}
