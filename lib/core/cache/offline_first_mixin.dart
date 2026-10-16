import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../error/failures.dart';
import 'cache_manager.dart';
import 'connectivity_service.dart';

/// A reusable mixin that wraps fetch calls with cache-or-network logic.
///
/// Prefer [watchListWithCache] / [watchSingleWithCache] (stale-while-
/// revalidate) for new reads. [fetchListWithCache] / [fetchSingleWithCache]
/// are the older network-first variants, kept for existing callers.
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
        unawaitedCacheWrite(
          cacheManager.cacheList(
            entityType: entityType,
            items: cacheItems,
            ttl: cacheTTL,
          ),
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
      return const Left(
        NetworkFailure('No internet connection and no cached data available'),
      );
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
        unawaitedCacheWrite(
          cacheManager.cacheSingle(
            entityType: entityType,
            entityKey: entityKey,
            data: toCacheItem(remoteData),
            ttl: cacheTTL,
          ),
        );

        return Right(remoteData);
      } catch (e) {
        debugPrint(
          '[OfflineFirst] Remote fetch failed for $entityType/$entityKey: $e',
        );
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
      debugPrint(
        '[OfflineFirst] Cache read failed for $entityType/$entityKey: $e',
      );
    }

    // 3. No data
    if (!connectivity.isConnected) {
      return const Left(
        NetworkFailure('No internet connection and no cached data available'),
      );
    }

    return Right(null);
  }

  /// Stale-while-revalidate list fetch — the preferred strategy for reads.
  ///
  /// 1. Emits the cached list straight away, if there is one.
  /// 2. If online, fetches from remote, emits the fresh list (skipped when it
  ///    matches the cache, so the UI doesn't rebuild for nothing) and writes
  ///    it to the cache in the background.
  ///
  /// A failed fetch is only an error when nothing was emitted: then the
  /// stream throws a [NetworkFailure] (offline) or [ServerFailure]. Riverpod
  /// providers can `yield*` this; `.future` resolves with the first value.
  ///
  /// [fetchFromRemote] returns raw JSON so the cache stores exactly what the
  /// API sent, rather than a model's `toJson()` round-trip.
  Stream<List<T>> watchListWithCache<T>({
    required String entityType,
    required Duration cacheTTL,
    required Future<List<Map<String, dynamic>>> Function() fetchFromRemote,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async* {
    List<Map<String, dynamic>>? cached;
    try {
      final rows = await cacheManager.getCachedList(entityType: entityType);
      if (rows.isNotEmpty) cached = rows;
    } catch (e) {
      debugPrint('[OfflineFirst] Cache read failed for $entityType: $e');
    }
    if (cached != null) yield cached.map(fromJson).toList();

    if (!connectivity.isConnected) {
      if (cached == null) {
        throw const NetworkFailure(
          'No internet connection and no cached data available',
        );
      }
      return;
    }

    final List<Map<String, dynamic>> fresh;
    try {
      fresh = await fetchFromRemote();
    } catch (e) {
      debugPrint('[OfflineFirst] Remote fetch failed for $entityType: $e');
      if (cached == null) {
        throw ServerFailure('Failed to fetch $entityType data');
      }
      return;
    }

    unawaitedCacheWrite(
      cacheManager.cacheList(
        entityType: entityType,
        items: fresh,
        ttl: cacheTTL,
      ),
    );
    if (!const DeepCollectionEquality().equals(cached, fresh)) {
      yield fresh.map(fromJson).toList();
    }
  }

  /// Stale-while-revalidate single-entity fetch. Same contract as
  /// [watchListWithCache]; a remote `null` (not found) is emitted as-is and
  /// not cached.
  Stream<T?> watchSingleWithCache<T>({
    required String entityType,
    required String entityKey,
    required Duration cacheTTL,
    required Future<Map<String, dynamic>?> Function() fetchFromRemote,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async* {
    Map<String, dynamic>? cached;
    try {
      cached = await cacheManager.getCachedSingle(
        entityType: entityType,
        entityKey: entityKey,
      );
    } catch (e) {
      debugPrint(
        '[OfflineFirst] Cache read failed for $entityType/$entityKey: $e',
      );
    }
    if (cached != null) yield fromJson(cached);

    if (!connectivity.isConnected) {
      if (cached == null) {
        throw const NetworkFailure(
          'No internet connection and no cached data available',
        );
      }
      return;
    }

    final Map<String, dynamic>? fresh;
    try {
      fresh = await fetchFromRemote();
    } catch (e) {
      debugPrint(
        '[OfflineFirst] Remote fetch failed for $entityType/$entityKey: $e',
      );
      if (cached == null) throw ServerFailure('Failed to fetch $entityType');
      return;
    }

    if (fresh == null) {
      yield null;
      return;
    }
    unawaitedCacheWrite(
      cacheManager.cacheSingle(
        entityType: entityType,
        entityKey: entityKey,
        data: fresh,
        ttl: cacheTTL,
      ),
    );
    if (!const DeepCollectionEquality().equals(cached, fresh)) {
      yield fromJson(fresh);
    }
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
    return Left(
      NetworkFailure('Operation queued for sync when connection is restored'),
    );
  }
}
