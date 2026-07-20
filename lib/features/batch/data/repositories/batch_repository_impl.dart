import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../datasources/batch_remote_data_source.dart';
import '../../domain/entities/batch.dart';
import '../models/batch_model.dart';
import '../../domain/repositories/batch_repository.dart';

class BatchRepositoryImpl implements BatchRepository {
  final BatchRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final ConnectivityService connectivity;

  BatchRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Batch>>> getBatches({
    required String departmentId,
  }) async {
    final cacheKey = 'batch_$departmentId';

    // Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteBatches = await remoteDataSource.getBatches(
          departmentId: departmentId,
        );
        final entities = remoteBatches.map((m) => m.toEntity()).toList();

        // Cache the result
        final cacheItems = remoteBatches.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: cacheItems,
          ttl: CacheTTL.batch,
        );

        return Right(entities);
      } catch (e) {
        debugPrint('[BatchRepo] Remote fetch failed: $e');
      }
    }

    // Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(entityType: cacheKey);
      if (cachedData.isNotEmpty) {
        final batches = cachedData
            .map((json) => BatchModel.fromJson(json).toEntity())
            .toList();
        debugPrint('[BatchRepo] Returning ${batches.length} cached batches');
        return Right(batches);
      }
    } catch (e) {
      debugPrint('[BatchRepo] Cache read failed: $e');
    }

    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection and no cached batch data available',
        ),
      );
    }

    return Left(ServerFailure('Failed to fetch batches'));
  }

  @override
  Future<Either<Failure, Batch>> createBatch(Batch batch) async {
    try {
      final model = BatchModel.fromEntity(batch);
      final result = await remoteDataSource.createBatch(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Batch>> updateBatch(Batch batch) async {
    try {
      final model = BatchModel.fromEntity(batch);
      final result = await remoteDataSource.updateBatch(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBatch(String id) async {
    try {
      await remoteDataSource.deleteBatch(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
