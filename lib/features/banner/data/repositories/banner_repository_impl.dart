import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_manager.dart';
import '../../../../core/cache/connectivity_service.dart';
import '../../../../core/cache/offline_first_mixin.dart';
import '../../../../core/cache/sync_manager.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/banner.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_remote_data_source.dart';
import '../models/banner_model.dart';

class BannerRepositoryImpl with OfflineFirstMixin implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;
  @override
  final CacheManager cacheManager;
  @override
  final ConnectivityService connectivity;
  final SyncManager syncManager;

  BannerRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
    required this.connectivity,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, List<Banner>>> getBanners({
    String? universityId,
    String? departmentId,
    String? mode,
  }) async {
    // Use a consistent cache key that doesn't depend on university/department
    // since the API already filters server-side.
    final cacheKey = mode == 'admin' ? 'banners_admin' : 'banners';

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteBanners = await remoteDataSource.getBanners(
          universityId: universityId,
          departmentId: departmentId,
          mode: mode,
        );
        final entities = remoteBanners.map((e) => e.toEntity()).toList();

        // Cache the result
        final cacheItems = remoteBanners.map((m) => m.toJson()).toList();
        await cacheManager.cacheList(
          entityType: cacheKey,
          items: cacheItems,
          ttl: CacheTTL.banner,
        );

        return Right(entities);
      } catch (e) {
        debugPrint('[BannerRepo] Remote fetch failed: $e');
        // Fall through to cache
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: cacheKey,
      );

      if (cachedData.isNotEmpty) {
        final banners = cachedData
            .map((json) => BannerModel.fromJson(json).toEntity())
            .toList();
        debugPrint('[BannerRepo] Returning ${banners.length} cached banners');
        return Right(banners);
      }
    } catch (e) {
      debugPrint('[BannerRepo] Cache read failed: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached banners available',
      ));
    }

    return Left(ServerFailure('Failed to fetch banners'));
  }

  @override
  Future<Either<Failure, Banner>> createBanner(Banner banner) async {
    final model = BannerModel.fromEntity(banner);

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final result = await remoteDataSource.createBanner(model);
        return Right(result.toEntity());
      } catch (e) {
        debugPrint('[BannerRepo] Remote create failed: $e');
      }
    }

    // 2. Queue for offline sync
    await syncManager.enqueue(
      operation: 'CREATE',
      entityType: 'banner',
      entityKey: banner.id,
      payload: model.toJson(),
      endpoint: '/banners',
      method: 'POST',
    );

    return Left(NetworkFailure(
      'Banner creation queued for sync when connection is restored',
    ));
  }

  @override
  Future<Either<Failure, Banner>> updateBanner(Banner banner) async {
    final model = BannerModel.fromEntity(banner);

    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final result = await remoteDataSource.updateBanner(model);
        return Right(result.toEntity());
      } catch (e) {
        debugPrint('[BannerRepo] Remote update failed: $e');
      }
    }

    // 2. Queue for offline sync
    await syncManager.enqueue(
      operation: 'UPDATE',
      entityType: 'banner',
      entityKey: banner.id,
      payload: model.toJson(),
      endpoint: '/banners/${banner.id}',
      method: 'PUT',
    );

    return Left(NetworkFailure(
      'Banner update queued for sync when connection is restored',
    ));
  }

  @override
  Future<Either<Failure, void>> deleteBanner(String id) async {
    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        await remoteDataSource.deleteBanner(id);
        // Invalidate banner cache
        await cacheManager.invalidate('banners');
        return const Right(null);
      } catch (e) {
        debugPrint('[BannerRepo] Remote delete failed: $e');
      }
    }

    // 2. Queue for offline sync
    await syncManager.enqueue(
      operation: 'DELETE',
      entityType: 'banner',
      entityKey: id,
      payload: {'id': id},
      endpoint: '/banners/$id',
      method: 'DELETE',
    );

    return Left(NetworkFailure(
      'Banner deletion queued for sync when connection is restored',
    ));
  }

}
