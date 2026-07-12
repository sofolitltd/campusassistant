import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../di.dart';
import '../network/api_client.dart';
import 'cache_manager.dart';
import 'connectivity_service.dart';

/// Processes pending offline write operations when connection is restored.
/// Also handles periodic background refresh of stale data.
class SyncManager {
  final OfflineDatabase _db;
  final ApiClient _apiClient;
  final ConnectivityService _connectivity;
  final CacheManager _cacheManager;

  Timer? _refreshTimer;
  bool _isSyncing = false;

  SyncManager({
    required OfflineDatabase db,
    required ApiClient apiClient,
    required ConnectivityService connectivity,
    required CacheManager cacheManager,
  })  : _db = db,
        _apiClient = apiClient,
        _connectivity = connectivity,
        _cacheManager = cacheManager;

  /// Whether a sync operation is currently in progress.
  bool get isSyncing => _isSyncing;

  /// Process all pending sync operations.
  /// Call this when app resumes or connectivity returns.
  Future<void> processPendingSyncs() async {
    if (_isSyncing) return;
    if (!_connectivity.isConnected) return;

    _isSyncing = true;
    try {
      final pending = await _db.getPendingSyncs();
      debugPrint('[SyncManager] Processing ${pending.length} pending syncs');

      for (final sync in pending) {
        try {
          final payload = Map<String, dynamic>.from(
            _jsonDecode(sync.payload),
          );

          switch (sync.method.toUpperCase()) {
            case 'POST':
              await _apiClient.post(sync.endpoint, data: payload);
              break;
            case 'PUT':
              await _apiClient.put(sync.endpoint, data: payload);
              break;
            case 'DELETE':
              await _apiClient.delete(sync.endpoint);
              break;
            case 'PATCH':
              await _apiClient.put(sync.endpoint, data: payload);
              break;
          }

          await _db.completeSync(sync.id);
          debugPrint('[SyncManager] Synced ${sync.entityType}/${sync.entityKey}');
        } catch (e) {
          debugPrint('[SyncManager] Failed to sync ${sync.entityKey}: $e');
          await _db.failSync(sync.id);
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Start periodic background refresh.
  /// Checks for stale data every [interval] and refreshes it.
  void startPeriodicRefresh({Duration interval = const Duration(minutes: 15)}) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(interval, (_) {
      refreshStaleData();
    });
  }

  /// Stop periodic refresh.
  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Refresh stale data in the background.
  /// Each entity type has its own staleness threshold.
  Future<void> refreshStaleData() async {
    if (!_connectivity.isConnected) return;

    debugPrint('[SyncManager] Checking for stale data...');

    final staleChecks = [
      ('banner', CacheTTL.banner),
      ('teacher', CacheTTL.teacher),
      ('routine', CacheTTL.routine),
      ('resource', CacheTTL.resource),
      ('student', CacheTTL.student),
      ('emergency', CacheTTL.emergency),
      ('club', CacheTTL.club),
      ('transport', CacheTTL.transport),
    ];

    for (final (entityType, maxAge) in staleChecks) {
      try {
        final isFresh = await _cacheManager.isFresh(entityType: entityType);
        if (!isFresh) {
          debugPrint('[SyncManager] $entityType cache is stale (TTL: $maxAge), refreshing...');
          // The actual refresh is handled by the repository layer.
          // We just signal that a refresh is needed.
        }
      } catch (e) {
        debugPrint('[SyncManager] Error checking $entityType: $e');
      }
    }

    // Prune expired cache entries
    final pruned = await _cacheManager.pruneExpired();
    if (pruned > 0) {
      debugPrint('[SyncManager] Pruned $pruned expired cache entries');
    }
  }

  /// Enqueue a write operation for offline sync.
  Future<void> enqueue({
    required String operation,
    required String entityType,
    required String entityKey,
    required Map<String, dynamic> payload,
    required String endpoint,
    required String method,
  }) async {
    await _db.enqueueSync(
      operation: operation,
      entityType: entityType,
      entityKey: entityKey,
      payload: payload,
      endpoint: endpoint,
      method: method,
    );
    debugPrint('[SyncManager] Enqueued $method $endpoint for $entityType/$entityKey');

    // Try to sync immediately if online
    if (_connectivity.isConnected) {
      processPendingSyncs();
    }
  }

  /// Get count of pending sync operations.
  Future<int> getPendingCount() async {
    return _db.getPendingSyncCount();
  }

  /// Clear the sync queue.
  Future<void> clearQueue() async {
    await _db.clearSyncQueue();
  }

  void dispose() {
    stopPeriodicRefresh();
  }

  Map<String, dynamic> _jsonDecode(String json) {
    return Map<String, dynamic>.from(
      const JsonDecoder().convert(json) as Map,
    );
  }
}

/// Riverpod provider for SyncManager.
final syncManagerProvider = Provider<SyncManager>((ref) {
  final db = ref.watch(offlineDatabaseProvider);
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
