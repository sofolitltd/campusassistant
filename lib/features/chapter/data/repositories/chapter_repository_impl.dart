import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '/core/cache/cache_manager.dart';
import '/core/cache/connectivity_service.dart';
import '/core/error/failures.dart';
import '../../domain/entities/chapter.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../datasources/chapter_remote_data_source.dart';
import '../models/chapter_model.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final ChapterRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  final Map<String, List<Chapter>> _chaptersCache = {};

  ChapterRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Chapter>>> getChapters(
    String courseCode, {
    String? batchId,
  }) async {
    final cacheKey = 'chapter_${courseCode}_batch_${batchId ?? 'all'}';

    // 0. In-memory cache (instant)
    if (_chaptersCache.containsKey(cacheKey)) {
      debugPrint('[ChapterRepo] Returning ${_chaptersCache[cacheKey]!.length} chapters from in-memory cache');
      return Right(_chaptersCache[cacheKey]!);
    }

    // 1. Try DB cache
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: cacheKey,
      );
      if (cachedData.isNotEmpty) {
        final chapters = cachedData
            .map((json) => ChapterModel.fromJson(json).toEntity())
            .toList();
        _chaptersCache[cacheKey] = chapters;
        debugPrint('[ChapterRepo] Returning ${chapters.length} cached chapters');
        return Right(chapters);
      }
    } catch (e) {
      debugPrint('[ChapterRepo] Cache read failed: $e');
    }

    // 2. Try remote if online
    if (connectivity.isConnected) {
      try {
        final chapters = await remoteDataSource.getChapters(
          courseCode,
          batchId: batchId,
        );
        final entities = chapters.map((m) => m.toEntity()).toList();

        final cacheItems = chapters.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: cacheItems,
          ttl: CacheTTL.chapter,
        );
        _chaptersCache[cacheKey] = entities;

        return Right(entities);
      } catch (e) {
        debugPrint('[ChapterRepo] Remote fetch failed: $e');
      }
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached chapter data available',
      ));
    }

    return Left(ServerFailure('Failed to fetch chapters'));
  }

  @override
  Future<Either<Failure, Chapter>> createChapter(Chapter chapter) async {
    try {
      final model = ChapterModel.fromEntity(chapter);
      final result = await remoteDataSource.createChapter(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chapter>> updateChapter(Chapter chapter) async {
    try {
      final model = ChapterModel.fromEntity(chapter);
      final result = await remoteDataSource.updateChapter(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChapter(String id) async {
    try {
      await remoteDataSource.deleteChapter(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
