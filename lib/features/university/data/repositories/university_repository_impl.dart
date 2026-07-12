import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/university.dart';
import '../../domain/repositories/university_repository.dart';
import '../datasources/university_remote_data_source.dart';
import '../models/university_model.dart';
import '../models/hall_model.dart';
import '../../domain/entities/hall.dart';

class UniversityRepositoryImpl implements UniversityRepository {
  final UniversityRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  UniversityRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<University>>> getUniversities() async {
    final cacheKey = 'all_universities';

    // Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteUniversities = await remoteDataSource.getUniversities();
        final entities = remoteUniversities.map((m) => m.toEntity()).toList();

        // Cache the result
        final cacheItems = remoteUniversities.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: cacheItems,
          ttl: CacheTTL.university,
        );

        return Right(entities);
      } catch (e) {
        debugPrint('[UniversityRepo] Remote fetch failed: $e');
      }
    }

    // Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: cacheKey,
      );
      if (cachedData.isNotEmpty) {
        final universities = cachedData
            .map((json) => UniversityModel.fromJson(json).toEntity())
            .toList();
        debugPrint('[UniversityRepo] Returning ${universities.length} cached universities');
        return Right(universities);
      }
    } catch (e) {
      debugPrint('[UniversityRepo] Cache read failed: $e');
    }

    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached university data available',
      ));
    }

    return Left(ServerFailure('Failed to fetch universities'));
  }

  @override
  Future<Either<Failure, University>> createUniversity(
    University university,
  ) async {
    try {
      final model = UniversityModel.fromEntity(university);
      final result = await remoteDataSource.createUniversity(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, University>> updateUniversity(
    University university,
  ) async {
    try {
      final model = UniversityModel.fromEntity(university);
      final result = await remoteDataSource.updateUniversity(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUniversity(String id) async {
    try {
      await remoteDataSource.deleteUniversity(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLogo(
    String filePath, {
    String? folder,
  }) async {
    try {
      final url = await remoteDataSource.uploadLogo(filePath, folder: folder);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLogoBytes(
    List<int> bytes,
    String fileName, {
    String? folder,
  }) async {
    try {
      final url = await remoteDataSource.uploadLogoBytes(
        bytes,
        fileName,
        folder: folder,
      );
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Hall>>> getHalls(String universityId) async {
    final cacheKey = 'hall_$universityId';

    // Try remote if online
    if (connectivity.isConnected) {
      try {
        final halls = await remoteDataSource.getHalls(universityId);
        final entities = halls.map((m) => m.toEntity()).toList();

        // Cache the result
        final cacheItems = halls.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: cacheItems,
          ttl: CacheTTL.hall,
        );

        return Right(entities);
      } catch (e) {
        debugPrint('[UniversityRepo] Remote fetch halls failed: $e');
      }
    }

    // Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: cacheKey,
      );
      if (cachedData.isNotEmpty) {
        final halls = cachedData
            .map((json) => HallModel.fromJson(json).toEntity())
            .toList();
        debugPrint('[UniversityRepo] Returning ${halls.length} cached halls');
        return Right(halls);
      }
    } catch (e) {
      debugPrint('[UniversityRepo] Cache read halls failed: $e');
    }

    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached hall data available',
      ));
    }

    return Left(ServerFailure('Failed to fetch halls'));
  }

  @override
  Future<Either<Failure, Hall>> createHall(Hall hall) async {
    try {
      final model = HallModel.fromEntity(hall);
      final result = await remoteDataSource.createHall(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Hall>> updateHall(Hall hall) async {
    try {
      final model = HallModel.fromEntity(hall);
      final result = await remoteDataSource.updateHall(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHall(String id) async {
    try {
      await remoteDataSource.deleteHall(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
