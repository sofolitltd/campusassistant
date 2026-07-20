import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';

/// Default TTL durations for different entity types.
class CacheTTL {
  static const banner = Duration(hours: 1);
  static const teacher = Duration(hours: 24);
  static const routine = Duration(hours: 6);
  static const resource = Duration(hours: 1);
  static const student = Duration(hours: 6);
  static const emergency = Duration(hours: 6);
  static const club = Duration(hours: 6);
  static const transport = Duration(hours: 12);
  static const course = Duration(hours: 12);
  static const chapter = Duration(hours: 12);
  static const syllabus = Duration(hours: 6);
  static const notice = Duration(hours: 6);
  static const semester = Duration(hours: 12);
  static const notification = Duration(minutes: 5);
  static const community = Duration(minutes: 5);
  static const profile = Duration(hours: 1);
  static const bookmark = Duration(minutes: 15);
  static const university = Duration(hours: 24);
  static const hall = Duration(hours: 24);
  static const department = Duration(hours: 6);
  static const batch = Duration(hours: 12);
  static const session = Duration(hours: 12);
  static const defaultTTL = Duration(hours: 1);
}

/// Manages reading and writing data to the Drift cache.
///
/// [_db] is null on web (no Drift/sqlite3 support there — see
/// app_database.dart's connection split). Every method degrades to a safe
/// no-op/empty-result in that case rather than throwing, so features built
/// on top of caching (community, resources, banners, etc.) still work on
/// web, just without local persistence.
class CacheManager {
  final OfflineDatabase? _db;

  static const _markerFileName = '.cache_cleared_at';
  static const _markerTtl = Duration(minutes: 5);

  CacheManager(this._db);

  Future<String> _markerPath() async {
    if (kIsWeb) return '';
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, _markerFileName);
  }

  Future<void> _writeClearMarker() async {
    if (kIsWeb) return;
    final file = File(await _markerPath());
    await file.writeAsString(DateTime.now().toIso8601String());
  }

  /// Whether the cache was cleared by the user within the last 5 minutes.
  /// Auto-deletes the marker if expired.
  Future<bool> isRecentlyCleared() async {
    if (kIsWeb) return false;
    final file = File(await _markerPath());
    if (!await file.exists()) return false;
    try {
      final content = await file.readAsString();
      final clearedAt = DateTime.parse(content);
      if (DateTime.now().difference(clearedAt) < _markerTtl) {
        return true;
      }
      await file.delete();
    } catch (_) {
      await file.delete();
    }
    return false;
  }

  /// Store a list of items in cache under the given entity type.
  Future<void> cacheList({
    required String entityType,
    required List<Map<String, dynamic>> items,
    Duration? ttl,
  }) async {
    await _db?.cacheEntities(
      entityType: entityType,
      items: items,
      ttl: ttl ?? CacheTTL.defaultTTL,
    );
  }

  /// Store a single item in cache.
  Future<void> cacheSingle({
    required String entityType,
    required String entityKey,
    required Map<String, dynamic> data,
    Duration? ttl,
  }) async {
    await _db?.cacheEntity(
      entityType: entityType,
      entityKey: entityKey,
      data: data,
      ttl: ttl ?? CacheTTL.defaultTTL,
    );
  }

  /// Get a cached list of items for the given entity type.
  /// Returns empty list if nothing cached or all expired.
  Future<List<Map<String, dynamic>>> getCachedList({
    required String entityType,
  }) async {
    if (_db == null) return [];
    return _db.getCachedEntities(entityType: entityType);
  }

  /// Get a single cached item.
  Future<Map<String, dynamic>?> getCachedSingle({
    required String entityType,
    required String entityKey,
  }) async {
    if (_db == null) return null;
    return _db.getCachedEntity(entityType: entityType, entityKey: entityKey);
  }

  /// Check if a cache entry exists and is fresh.
  Future<bool> isFresh({required String entityType, String? entityKey}) async {
    if (_db == null) return false;
    if (entityKey != null) {
      return _db.isCacheFresh(entityType: entityType, entityKey: entityKey);
    }
    return _db.hasFreshCache(entityType: entityType);
  }

  /// Invalidate all cache for an entity type.
  Future<void> invalidate(String entityType) async {
    await _db?.invalidateCache(entityType);
  }

  /// Invalidate a specific cache entry.
  Future<void> invalidateEntry({
    required String entityType,
    required String entityKey,
  }) async {
    await _db?.invalidateCacheEntry(
      entityType: entityType,
      entityKey: entityKey,
    );
  }

  /// Remove all expired cache entries.
  Future<int> pruneExpired() async {
    if (_db == null) return 0;
    return _db.pruneExpiredCache();
  }

  /// Clear all cache. Writes a marker so automatic refresh is skipped briefly.
  Future<void> clearAll() async {
    await _db?.clearAllCache();
    await _writeClearMarker();
  }

  /// Get cache statistics grouped by entity type.
  Future<List<CacheStat>> getStats() async {
    if (_db == null) return [];
    return _db.getCacheStats();
  }

  /// Get total number of cache entries.
  Future<int> getTotalCount() async {
    if (_db == null) return 0;
    return _db.getTotalCacheCount();
  }
}

/// Riverpod provider for CacheManager.
final cacheManagerProvider = Provider<CacheManager>((ref) {
  final db = kIsWeb ? null : ref.watch(offlineDatabaseProvider);
  return CacheManager(db);
});
