import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../datasources/session_remote_data_source.dart';
import '../../domain/entities/session.dart';
import '../models/session_model.dart';
import '../../domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;

  SessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Session>>> getSessions({
    required String universityId,
  }) async {
    try {
      final result = await remoteDataSource.getSessions(
        universityId: universityId,
      );
      return Right(result.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Session>> createSession(Session session) async {
    try {
      final model = SessionModel.fromEntity(session);
      final result = await remoteDataSource.createSession(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Session>> updateSession(Session session) async {
    try {
      final model = SessionModel.fromEntity(session);
      final result = await remoteDataSource.updateSession(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String id) async {
    try {
      await remoteDataSource.deleteSession(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
