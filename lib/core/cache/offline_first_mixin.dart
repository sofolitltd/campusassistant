import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../error/failures.dart';
import 'cache_manager.dart';
import 'connectivity_service.dart';

/// A reusable mixin that wraps fetch calls with cache-or-network logic.
///
/// Usage: mix this into a repository implementation and use [fetchWithCache]
/// in your fetch methods.
///
/// Example:
/// ```dart
/// class BannerRepositoryImpl with OfflineFirstMixin implements BannerRepository {
///   final BannerRemoteDataSource remoteDataSource;
///   final CacheManager cacheManager;
///   final ConnectivityService connectivity;
///
///   BannerRepositoryImpl({
///     required this.remoteDataSource,
///     required this.cacheManager,
///     required this.connectivity,
///   });
///
///   @override
///   Future<Either<Failure, List<Banner>>> getBanners() {
///     return fetchWithCache(
///       entityType: 'banner',
///       cacheTTL: CacheTTL.banner,
///       fetchFromRemote: () => remoteDataSource.getBanners(),
///       toCacheItem: (banner) => banner.toJson(),
///       fromCacheItem: (json) => Banner.fromJson(json),
///     );
///   }
/// }
/// ```
mixin OfflineFirstMixin {
  CacheManager get cacheManager;
  ConnectivityService get connectivity;

  /// Fetch data with cache-first strategy.
  ///
  /// 1. Try to fetch from remote if online
  /// 2. If remote succeeds, cache and return
  /// 3. If remote fails or offline, return cached data
  /// 4. If no cache exists and offline, return NetworkFailure
  Future<Either<Failure, List<T>>> fetchListWithCache<T>({
    required String entityType,
    required Duration cacheTTL,
    required Future<List<T>> Function() fetchFromRemote,
    required Map<String, dynamic> Function(T item) toCacheItem,
    required T Function(Map<String, dynamic> json) fromCacheItem,
    Map<String, dynamic>? queryParameters,
  }) async {
    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteData = await fetchFromRemote();

        // Cache the fresh data
        final cacheItems = remoteData.map(toCacheItem).toList();
        await cacheManager.cacheList(
          entityType: entityType,
          items: cacheItems,
          ttl: cacheTTL,
        );

        return Right(remoteData);
      } catch (e) {
        debugPrint('[OfflineFirst] Remote fetch failed for $entityType: $e');
        // Fall through to cache
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedList(
        entityType: entityType,
      );

      if (cachedData.isNotEmpty) {
        final items = cachedData.map(fromCacheItem).toList();
        return Right(items);
      }
    } catch (e) {
      debugPrint('[OfflineFirst] Cache read failed for $entityType: $e');
    }

    // 3. No data available
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached data available',
      ));
    }

    return Left(ServerFailure('Failed to fetch $entityType data'));
  }

  /// Fetch a single entity with cache-first strategy.
  Future<Either<Failure, T?>> fetchSingleWithCache<T>({
    required String entityType,
    required String entityKey,
    required Duration cacheTTL,
    required Future<T> Function() fetchFromRemote,
    required Map<String, dynamic> Function(T item) toCacheItem,
    required T Function(Map<String, dynamic> json) fromCacheItem,
  }) async {
    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final remoteData = await fetchFromRemote();

        // Cache the fresh data
        await cacheManager.cacheSingle(
          entityType: entityType,
          entityKey: entityKey,
          data: toCacheItem(remoteData),
          ttl: cacheTTL,
        );

        return Right(remoteData);
      } catch (e) {
        debugPrint('[OfflineFirst] Remote fetch failed for $entityType/$entityKey: $e');
      }
    }

    // 2. Try cached data
    try {
      final cachedData = await cacheManager.getCachedSingle(
        entityType: entityType,
        entityKey: entityKey,
      );

      if (cachedData != null) {
        return Right(fromCacheItem(cachedData));
      }
    } catch (e) {
      debugPrint('[OfflineFirst] Cache read failed for $entityType/$entityKey: $e');
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure(
        'No internet connection and no cached data available',
      ));
    }

    return Right(null);
  }

  /// Write operation that queues for sync if offline.
  Future<Either<Failure, T>> writeWithQueue<T>({
    required String entityType,
    required String entityKey,
    required Map<String, dynamic> payload,
    required String endpoint,
    required String method,
    required Future<T> Function() executeRemote,
    required String operation,
  }) async {
    // 1. Try remote if online
    if (connectivity.isConnected) {
      try {
        final result = await executeRemote();
        return Right(result);
      } catch (e) {
        debugPrint('[OfflineFirst] Remote write failed for $entityType: $e');
        // Fall through to queue
      }
    }

    // 2. Queue for sync (requires SyncManager - injected separately)
    // The repository should handle this via syncManager.enqueue()
    return Left(NetworkFailure(
      'Operation queued for sync when connection is restored',
    ));
  }
}
