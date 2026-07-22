import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/club.dart';
import '../../domain/repositories/club_repository.dart';
import '../datasources/club_remote_data_source.dart';
import '../models/club_model.dart';

class ClubRepositoryImpl implements ClubRepository {
  final ClubRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  ClubRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Club>>> getClubs({
    required String universityId,
    String? departmentId,
    required String type,
  }) async {
    final cacheKey =
        'uni_$universityId${departmentId != null ? '_dept_$departmentId' : ''}_type_$type';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteClubs = await remoteDataSource.getClubs(
          universityId: universityId,
          departmentId: departmentId,
          type: type,
        );
        final entities = remoteClubs.map((m) => m.toEntity()).toList();

        // Cache the result
        final cacheItems = remoteClubs.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: 'club_$cacheKey',
          items: cacheItems,
          ttl: CacheTTL.club,
        );

        return Right(entities);
      } catch (e) {
        debugPrint('[ClubRepo] Remote fetch failed: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: 'club_$cacheKey',
      );

      if (cachedData.isNotEmpty) {
        final clubs = cachedData
            .map((json) => ClubModel.fromJson(json).toEntity())
            .toList();
        debugPrint('[ClubRepo] Returning ${clubs.length} cached clubs');
        return Right(clubs);
      }
    } catch (e) {
      debugPrint('[ClubRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure('No internet connection and no cached clubs available'),
      );
    }

    return Left(ServerFailure('Failed to fetch clubs'));
  }

  @override
  Future<Either<Failure, void>> followClub(String clubId) async {
    try {
      await remoteDataSource.followClub(clubId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to follow club: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowClub(String clubId) async {
    try {
      await remoteDataSource.unfollowClub(clubId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to unfollow club: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> joinClub(String clubId) async {
    try {
      await remoteDataSource.joinClub(clubId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to join club: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveClub(String clubId) async {
    try {
      await remoteDataSource.leaveClub(clubId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to leave club: $e'));
    }
  }

  @override
  Future<Either<Failure, Club>> suggestClub(Club club) async {
    try {
      final saved = await remoteDataSource.suggestClub(
        ClubModel.fromEntity(club),
      );
      return Right(saved.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to submit club: $e'));
    }
  }
}
