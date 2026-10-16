import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../di.dart';
import '../network/api_client.dart';
import 'cache_manager.dart';
import 'connectivity_service.dart';

/// Processes pending offline write operations when connection is restored,
/// and periodically prunes expired cache entries.
///
/// [_db] is null on web (no Drift/sqlite3 support there — see
/// app_database.dart's connection split). The offline write queue simply
/// doesn't exist on web, so every method touching it degrades to a no-op.
class SyncManager {
  final OfflineDatabase? _db;
  final ApiClient _apiClient;
  final ConnectivityService _connectivity;
  final CacheManager _cacheManager;

  Timer? _refreshTimer;
  bool _isSyncing = false;

  SyncManager({
    required this._db,
    required this._apiClient,
    required this._connectivity,
    required this._cacheManager,
  });

  /// Whether a sync operation is currently in progress.
  bool get isSyncing => _isSyncing;

  /// Process all pending sync operations.
  /// Call this when app resumes or connectivity returns.
  Future<void> processPendingSyncs() async {
    final db = _db;
    if (db == null) return;
    if (_isSyncing) return;
    if (!_connectivity.isConnected) return;

    _isSyncing = true;
    try {
      final pending = await db.getPendingSyncs();
      debugPrint('[SyncManager] Processing ${pending.length} pending syncs');

      for (final sync in pending) {
        try {
          final payload = Map<String, dynamic>.from(_jsonDecode(sync.payload));

          switch (sync.method.toUpperCase()) {
            case 'POST':
              await _apiClient.post(sync.endpoint, data: payload);
            case 'PUT':
              await _apiClient.put(sync.endpoint, data: payload);
            case 'DELETE':
              await _apiClient.delete(sync.endpoint);
            case 'PATCH':
              await _apiClient.patch(sync.endpoint, data: payload);
          }

          await db.completeSync(sync.id);
          debugPrint(
            '[SyncManager] Synced ${sync.entityType}/${sync.entityKey}',
          );
        } on DioException catch (e) {
          if (_isNetworkFailure(e)) {
            // Offline again: the rest would fail the same way, and it isn't
            // this operation's fault, so don't count an attempt.
            debugPrint('[SyncManager] Network lost; stopping this pass');
            break;
          }
          await _recordFailure(db, sync, e, permanent: _isPermanent(e));
        } catch (e) {
          await _recordFailure(db, sync, e, permanent: false);
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Attempts before an operation is moved to the dead-letter status.
  static const maxRetries = 5;

  Future<void> _recordFailure(
    OfflineDatabase db,
    SyncQueueData sync,
    Object error, {
    required bool permanent,
  }) async {
    final dead = await db.failSync(
      sync.id,
      maxRetries: permanent ? 0 : maxRetries,
    );
    debugPrint(
      '[SyncManager] Failed to sync ${sync.entityType}/${sync.entityKey}'
      '${dead ? ' — giving up (dead-lettered)' : ''}: $error',
    );
  }

  static bool _isNetworkFailure(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => true,
    _ => false,
  };

  /// A 4xx (other than timeout/rate-limit) means the server rejected the
  /// request itself; resending the same body won't change that.
  static bool _isPermanent(DioException e) {
    final status = e.response?.statusCode;
    if (status == null) return false;
    return status >= 400 && status < 500 && status != 408 && status != 429;
  }

  /// Start the periodic cache prune, every [interval].
  void startPeriodicRefresh({Duration interval = const Duration(minutes: 15)}) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(interval, (_) => _pruneExpiredCache());
  }

  /// Stop periodic refresh.
  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  // Repositories refresh their own data (stale-while-revalidate, #9); a
  // periodic "is it stale?" check here could only log, so all that's left is
  // keeping the cache table from growing with dead rows.
  Future<void> _pruneExpiredCache() async {
    try {
      final pruned = await _cacheManager.pruneExpired();
      if (pruned > 0) {
        debugPrint('[SyncManager] Pruned $pruned expired cache entries');
      }
    } catch (e) {
      debugPrint('[SyncManager] Cache prune failed: $e');
    }
  }

  /// Enqueue a write operation for offline sync. No-op on web — there's no
  /// local queue to persist to there, so a failed write is simply lost
  /// rather than retried later.
  Future<void> enqueue({
    required String operation,
    required String entityType,
    required String entityKey,
    required Map<String, dynamic> payload,
    required String endpoint,
    required String method,
  }) async {
    final db = _db;
    if (db == null) return;

    await db.enqueueSync(
      operation: operation,
      entityType: entityType,
      entityKey: entityKey,
      payload: payload,
      endpoint: endpoint,
      method: method,
    );
    debugPrint(
      '[SyncManager] Enqueued $method $endpoint for $entityType/$entityKey',
    );

    // Try to sync immediately if online
    if (_connectivity.isConnected) {
      processPendingSyncs();
    }
  }

  /// Get count of pending sync operations.
  Future<int> getPendingCount() async {
    if (_db == null) return 0;
    return _db.getPendingSyncCount();
  }

  /// Clear the sync queue.
  Future<void> clearQueue() async {
    await _db?.clearSyncQueue();
  }

  void dispose() {
    stopPeriodicRefresh();
  }

  Map<String, dynamic> _jsonDecode(String json) {
    return Map<String, dynamic>.from(const JsonDecoder().convert(json) as Map);
  }
}

/// Riverpod provider for SyncManager.
final syncManagerProvider = Provider<SyncManager>((ref) {
  final db = kIsWeb ? null : ref.watch(offlineDatabaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final cacheManager = ref.watch(cacheManagerProvider);

  final manager = SyncManager(
    db: db,
    apiClient: apiClient,
    connectivity: connectivity,
    cacheManager: cacheManager,
  );

  // Start periodic refresh
  manager.startPeriodicRefresh();

  ref.onDispose(() => manager.dispose());

  return manager;
});

/// Provider that triggers pending syncs. Can be invoked manually.
final processSyncsProvider = Provider<bool>((ref) {
  final syncManager = ref.watch(syncManagerProvider);
  // Trigger sync on creation
  syncManager.processPendingSyncs();
  return syncManager.isSyncing;
});
