import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../datasources/session_remote_data_source.dart';
import '../../domain/entities/session.dart';
import '../models/session_model.dart';
import '../../domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  SessionRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Session>>> getSessions({
    required String universityId,
  }) async {
    final cacheKey = 'session_$universityId';

    // Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteSessions = await remoteDataSource.getSessions(
          universityId: universityId,
        );
        final entities = remoteSessions.map((m) => m.toEntity()).toList();

        // Cache the result
        final cacheItems = remoteSessions.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: cacheItems,
          ttl: CacheTTL.session,
        );

        return Right(entities);
      } catch (e) {
        debugPrint('[SessionRepo] Remote fetch failed: $e');
      }
    }

    // Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(entityType: cacheKey);
      if (cachedData.isNotEmpty) {
        final sessions = cachedData
            .map((json) => SessionModel.fromJson(json).toEntity())
            .toList();
        debugPrint(
          '[SessionRepo] Returning ${sessions.length} cached sessions',
        );
        return Right(sessions);
      }
    } catch (e) {
      debugPrint('[SessionRepo] Cache read failed: $e');
    }

    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection and no cached session data available',
        ),
      );
    }

    return Left(ServerFailure('Failed to fetch sessions'));
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
