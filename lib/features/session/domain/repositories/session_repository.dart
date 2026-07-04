import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/session.dart';

abstract class SessionRepository {
  Future<Either<Failure, List<Session>>> getSessions({
    required String universityId,
  });
  Future<Either<Failure, Session>> createSession(Session session);
  Future<Either<Failure, Session>> updateSession(Session session);
  Future<Either<Failure, void>> deleteSession(String id);
}
