import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

// ─── Drift Tables ───

/// Cache entries for offline data storage.
/// Each row stores a JSON-serialized entity with TTL-based expiration.
class CacheEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityKey => text()();
  TextColumn get data => text()();
  DateTimeColumn get cachedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [{entityType, entityKey}];
}

/// Queue for write operations performed while offline.
/// Synced to server when connection is restored.
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operation => text()(); // CREATE, UPDATE, DELETE
  TextColumn get entityType => text()();
  TextColumn get entityKey => text()();
  TextColumn get payload => text()(); // JSON-encoded request body
  TextColumn get endpoint => text()(); // API endpoint to call
  TextColumn get method => text()(); // HTTP method
  TextColumn get status => text().withDefault(const Constant<String>('pending'))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant<int>(0))();
}

// ─── Drift Database (Cache + Sync) ───

@DriftDatabase(tables: [CacheEntries, SyncQueue])
class OfflineDatabase extends _$OfflineDatabase {
  OfflineDatabase() : super(_openConnection());

  // Bump version when changing schema
  @override
  int get schemaVersion => 1;

  // ── Cache Operations ──

  /// Store or update a cache entry. If an entry with the same entityType+entityKey
  /// exists, it is replaced.
  Future<void> cacheEntity({
    required String entityType,
    required String entityKey,
    required Map<String, dynamic> data,
    required Duration ttl,
  }) async {
    final now = DateTime.now();
    await into(cacheEntries).insert(
      CacheEntriesCompanion(
        entityType: Value(entityType),
        entityKey: Value(entityKey),
        data: Value(jsonEncode(data)),
        cachedAt: Value(now),
        expiresAt: Value(now.add(ttl)),
      ),
      mode: InsertMode.replace,
    );
  }

  /// Cache a list of entities under the same entityType.
  /// Each item is keyed by its 'id' field.
  Future<void> cacheEntities({
    required String entityType,
    required List<Map<String, dynamic>> items,
    required Duration ttl,
  }) async {
    final now = DateTime.now();
    await batch((batch) {
      for (final item in items) {
        final key = item['id']?.toString() ?? '';
        if (key.isEmpty) continue;
        batch.insert(
          cacheEntries,
          CacheEntriesCompanion(
            entityType: Value(entityType),
            entityKey: Value(key),
            data: Value(jsonEncode(item)),
            cachedAt: Value(now),
            expiresAt: Value(now.add(ttl)),
          ),
          mode: InsertMode.replace,
        );
      }
    });
  }

  /// Get a single cached entity. Returns null if expired or not found.
  Future<Map<String, dynamic>?> getCachedEntity({
    required String entityType,
    required String entityKey,
  }) async {
    final query = select(cacheEntries)
      ..where((t) =>
          t.entityType.equals(entityType) &
          t.entityKey.equals(entityKey) &
          t.expiresAt.isBiggerThanValue(DateTime.now()));
    final result = await query.getSingleOrNull();
    if (result == null) return null;
    return jsonDecode(result.data) as Map<String, dynamic>;
  }

  /// Get all cached entities of a type that haven't expired.
  Future<List<Map<String, dynamic>>> getCachedEntities({
    required String entityType,
  }) async {
    final now = DateTime.now();
    final query = select(cacheEntries)
      ..where((t) =>
          t.entityType.equals(entityType) &
          t.expiresAt.isBiggerThanValue(now));
    final results = await query.get();
    return results
        .map((r) => jsonDecode(r.data) as Map<String, dynamic>)
        .toList();
  }

  /// Check if a cache entry exists and is fresh (not expired).
  Future<bool> isCacheFresh({
    required String entityType,
    required String entityKey,
  }) async {
    final now = DateTime.now();
    final query = select(cacheEntries)
      ..where((t) =>
          t.entityType.equals(entityType) &
          t.entityKey.equals(entityKey) &
          t.expiresAt.isBiggerThanValue(now));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// Check if any cache entry of this type is still fresh.
  Future<bool> hasFreshCache({required String entityType}) async {
    final now = DateTime.now();
    final query = select(cacheEntries)
      ..where((t) =>
          t.entityType.equals(entityType) &
          t.expiresAt.isBiggerThanValue(now))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// Invalidate (delete) all cache entries for an entity type.
  Future<void> invalidateCache(String entityType) async {
    await (delete(cacheEntries)..where((t) => t.entityType.equals(entityType))).go();
  }

  /// Invalidate a specific cache entry.
  Future<void> invalidateCacheEntry({
    required String entityType,
    required String entityKey,
  }) async {
    await (delete(cacheEntries)
          ..where((t) =>
              t.entityType.equals(entityType) &
              t.entityKey.equals(entityKey)))
        .go();
  }

  /// Clear all expired cache entries.
  Future<int> pruneExpiredCache() async {
    final now = DateTime.now();
    return (delete(cacheEntries)
          ..where((t) => t.expiresAt.isSmallerThanValue(now)))
        .go();
  }

  /// Clear all cache entries.
  Future<void> clearAllCache() async {
    await delete(cacheEntries).go();
  }

  /// Clear cache entries for a specific entity type.
  Future<void> clearEntityCache(String entityType) async {
    await (delete(cacheEntries)..where((t) => t.entityType.equals(entityType)))
        .go();
  }

  /// Delete a single cache entry by entity type and key.
  Future<void> deleteSingleCache(String entityType, String entityKey) async {
    await (delete(cacheEntries)
          ..where((t) => t.entityType.equals(entityType))
          ..where((t) => t.entityKey.equals(entityKey)))
        .go();
  }

  /// Get cache statistics: entity type, entry count, and total data size.
  Future<List<CacheStat>> getCacheStats() async {
    final results = await (select(cacheEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.entityType)]))
        .get();
    final grouped = <String, int>{};
    final sizeByType = <String, int>{};
    for (final entry in results) {
      grouped[entry.entityType] = (grouped[entry.entityType] ?? 0) + 1;
      sizeByType[entry.entityType] =
          (sizeByType[entry.entityType] ?? 0) + entry.data.length;
    }
    return grouped.entries.map((e) => CacheStat(
          entityType: e.key,
          entryCount: e.value,
          totalBytes: sizeByType[e.key] ?? 0,
        )).toList()
      ..sort((a, b) => b.entryCount.compareTo(a.entryCount));
  }

  /// Get total number of cache entries.
  Future<int> getTotalCacheCount() async {
    return (select(cacheEntries)).get().then((r) => r.length);
  }

  // ── Sync Queue Operations ──

  /// Add an operation to the sync queue.
  Future<void> enqueueSync({
    required String operation,
    required String entityType,
    required String entityKey,
    required Map<String, dynamic> payload,
    required String endpoint,
    required String method,
  }) async {
    await into(syncQueue).insert(SyncQueueCompanion.insert(
      operation: operation,
      entityType: entityType,
      entityKey: entityKey,
      payload: jsonEncode(payload),
      endpoint: endpoint,
      method: method,
      createdAt: DateTime.now(),
    ));
  }

  /// Get all pending sync operations, ordered by creation time.
  Future<List<SyncQueueData>> getPendingSyncs() async {
    final query = select(syncQueue)
      ..where((t) => t.status.equals('pending'))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return query.get();
  }

  /// Mark a sync operation as completed and remove it.
  Future<void> completeSync(int id) async {
    await (delete(syncQueue)..where((t) => t.id.equals(id))).go();
  }

  /// Mark a sync operation as failed and increment retry count.
  Future<void> failSync(int id) async {
    final query = select(syncQueue)..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();
    if (result != null) {
      await (update(syncQueue)..where((t) => t.id.equals(id))).write(
        SyncQueueCompanion(
          status: const Value('failed'),
          retryCount: Value(result.retryCount + 1),
        ),
      );
    }
  }

  /// Reset failed operations back to pending for retry.
  Future<void> retryFailedSyncs() async {
    await (update(syncQueue)..where((t) => t.status.equals('failed'))).write(
      const SyncQueueCompanion(status: Value('pending')),
    );
  }

  /// Clear all sync queue entries.
  Future<void> clearSyncQueue() async {
    await delete(syncQueue).go();
  }

  /// Get count of pending sync operations.
  Future<int> getPendingSyncCount() async {
    final query = select(syncQueue)
      ..where((t) => t.status.equals('pending'));
    final results = await query.get();
    return results.length;
  }
}

/// Statistics for a cached entity type.
class CacheStat {
  final String entityType;
  final int entryCount;
  final int totalBytes;

  const CacheStat({
    required this.entityType,
    required this.entryCount,
    required this.totalBytes,
  });

  String get formattedSize {
    if (totalBytes < 1024) return '$totalBytes B';
    if (totalBytes < 1024 * 1024) return '${(totalBytes / 1024).toStringAsFixed(1)} KB';
    return '${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) {
      throw UnsupportedError('Drift database not available on web');
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'campusassistant_offline.db'));
    return NativeDatabase.createInBackground(file);
  });
}

// ─── Existing Chat Database (sqflite) ───

class ChatDatabase {
  static sqflite.Database? _instance;

  static Future<sqflite.Database> get instance async {
    if (kIsWeb) throw UnsupportedError('Local database not available on web');
    if (_instance != null) return _instance!;
    final dbPath = await sqflite.getDatabasesPath();
    _instance = await sqflite.openDatabase(
      p.join(dbPath, 'campusassistant_chat.db'),
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _instance!;
  }

  static Future<void> _onCreate(sqflite.Database db, int version) async {
    await _createTables(db);
  }

  static Future<void> _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE outgoing_messages (
          temp_id TEXT PRIMARY KEY,
          conversation_id TEXT NOT NULL,
          sender_id TEXT NOT NULL,
          text TEXT NOT NULL,
          replied_to_id TEXT,
          status TEXT NOT NULL DEFAULT 'pending',
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS deleted_messages (
          id TEXT NOT NULL,
          conversation_id TEXT NOT NULL,
          deleted_at TEXT NOT NULL,
          PRIMARY KEY (id, conversation_id)
        )
      ''');
    }
  }

  static Future<void> _createTables(sqflite.Database db) async {
    await db.execute('''
      CREATE TABLE conversations (
        id TEXT PRIMARY KEY,
        last_message TEXT NOT NULL DEFAULT '',
        last_message_time TEXT,
        last_message_sender TEXT,
        unread_count INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'accepted',
        initiator_id TEXT,
        participant_data TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        conversation_id TEXT NOT NULL,
        sender_id TEXT NOT NULL,
        text TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        read INTEGER NOT NULL DEFAULT 0,
        replied_to_id TEXT,
        replied_to_text TEXT,
        message_status TEXT NOT NULL DEFAULT 'sent',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sender_name TEXT
      )
    ''');
    await db.execute('''
      CREATE INDEX idx_messages_conv ON messages(conversation_id, created_at DESC)
    ''');
    await db.execute('''
      CREATE TABLE outgoing_messages (
        temp_id TEXT PRIMARY KEY,
        conversation_id TEXT NOT NULL,
        sender_id TEXT NOT NULL,
        text TEXT NOT NULL,
        replied_to_id TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS deleted_messages (
        id TEXT NOT NULL,
        conversation_id TEXT NOT NULL,
        deleted_at TEXT NOT NULL,
        PRIMARY KEY (id, conversation_id)
      )
    ''');
  }

  /// Close and reset for testing
  static Future<void> reset() async {
    await _instance?.close();
    _instance = null;
  }

  // ── Conversations ──

  static Future<List<Map<String, dynamic>>> getConversations() async {
    final db = await instance;
    return db.query('conversations', orderBy: 'last_message_time DESC');
  }

  static Future<Map<String, dynamic>?> getConversation(String id) async {
    final db = await instance;
    final rows = await db.query('conversations', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : rows.first;
  }

  static Future<void> upsertConversation(Map<String, dynamic> json) async {
    final db = await instance;
    await db.insert('conversations', _flattenConversation(json),
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  }

  static Future<void> upsertConversations(List<Map<String, dynamic>> list) async {
    final db = await instance;
    final batch = db.batch();
    for (final json in list) {
      batch.insert('conversations', _flattenConversation(json),
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> deleteConversation(String id) async {
    final db = await instance;
    await db.delete('conversations', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateConversationLastMessage({
    required String conversationId,
    String? lastMessage,
    String? lastMessageTime,
    String? lastMessageSender,
  }) async {
    final db = await instance;
    await db.update(
      'conversations',
      {
        'last_message': lastMessage ?? '',
        'last_message_time': lastMessageTime,
        'last_message_sender': lastMessageSender,
      },
      where: 'id = ?',
      whereArgs: [conversationId],
    );
  }

  // ── Messages ──

  static Future<List<Map<String, dynamic>>> getMessages(
    String conversationId,
  ) async {
    final db = await instance;
    return db.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'created_at ASC',
    );
  }

  static Future<Map<String, dynamic>?> getLastMessage(
    String conversationId,
  ) async {
    final db = await instance;
    final rows = await db.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  static Future<void> upsertMessage(Map<String, dynamic> json) async {
    final db = await instance;
    await db.insert('messages', _flattenMessage(json),
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  }

  static Future<void> upsertMessages(List<Map<String, dynamic>> list) async {
    final db = await instance;
    final batch = db.batch();
    for (final json in list) {
      batch.insert('messages', _flattenMessage(json),
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> deleteMessage(String id) async {
    final db = await instance;
    await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteConversationMessages(String conversationId) async {
    final db = await instance;
    await db.delete('messages',
        where: 'conversation_id = ?', whereArgs: [conversationId]);
  }

  // ── Deleted Message Tracking ──

  static Future<void> addDeletedMessage(String id) async {
    final db = await instance;
    await db.insert('deleted_messages', {
      'id': id,
      'conversation_id': '',
      'deleted_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  }

  static Future<void> addDeletedMessages(List<String> ids) async {
    final db = await instance;
    final batch = db.batch();
    final now = DateTime.now().toIso8601String();
    for (final id in ids) {
      batch.insert('deleted_messages', {
        'id': id,
        'conversation_id': '',
        'deleted_at': now,
      }, conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<Set<String>> getDeletedMessageIds() async {
    final db = await instance;
    final rows = await db.query('deleted_messages');
    return rows.map((r) => r['id'] as String).toSet();
  }

  static Future<void> removeDeletedMessage(String id) async {
    final db = await instance;
    await db.delete('deleted_messages', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearDeletedMessages() async {
    final db = await instance;
    await db.delete('deleted_messages');
  }

  /// Remove deleted IDs from a server-fetched message list.
  static Future<List<Map<String, dynamic>>> filterDeletedMessages(
    List<Map<String, dynamic>> msgs,
  ) async {
    final deleted = await getDeletedMessageIds();
    if (deleted.isEmpty) return msgs;
    return msgs.where((m) => !deleted.contains(m['id'] as String)).toList();
  }

  // ── Clear All ──

  static Future<void> clearAll() async {
    final db = await instance;
    await db.delete('messages');
    await db.delete('conversations');
    await db.delete('outgoing_messages');
    await db.delete('deleted_messages');
  }

  // ── JSON normalisers ──

  static Map<String, dynamic> _flattenConversation(Map<String, dynamic> json) {
    return {
      'id': json['id'] as String,
      'last_message': json['lastMessage'] as String? ?? '',
      'last_message_time': json['lastMessageTime'] as String?,
      'last_message_sender': json['lastMessageSender'] as String?,
      'unread_count': json['unreadCount'] as int? ?? 0,
      'status': json['status'] as String? ?? 'accepted',
      'initiator_id': json['initiatorId'] as String?,
      'participant_data':
          json['participantData'] != null ? jsonEncode(json['participantData']) : null,
      'created_at': json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      'updated_at': json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> _flattenMessage(Map<String, dynamic> json) {
    return {
      'id': json['id'] as String,
      'conversation_id': json['conversationId'] as String,
      'sender_id': json['senderId'] as String,
      'text': json['text'] as String? ?? '',
      'timestamp': json['timestamp'] as String? ?? json['createdAt'] as String? ?? '',
      'read': json['read'] == true ? 1 : 0,
      'replied_to_id': json['repliedToId'] as String?,
      'replied_to_text': json['repliedToText'] as String?,
      'message_status': json['messageStatus'] as String? ?? 'sent',
      'created_at': json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      'updated_at': json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
      'sender_name': json['senderName'] as String?,
    };
  }

  // ── Outgoing Message Queue ──

  static Future<List<Map<String, dynamic>>> getOutgoingPending() async {
    final db = await instance;
    return db.query('outgoing_messages',
        where: 'status IN (?, ?)', whereArgs: ['pending', 'failed']);
  }

  static Future<void> insertOutgoing(Map<String, dynamic> row) async {
    final db = await instance;
    await db.insert('outgoing_messages', row,
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  }

  static Future<void> deleteOutgoing(String tempId) async {
    final db = await instance;
    await db.delete('outgoing_messages', where: 'temp_id = ?', whereArgs: [tempId]);
  }

  static Future<void> markOutgoingStatus(String tempId, String status) async {
    final db = await instance;
    await db.update('outgoing_messages', {'status': status},
        where: 'temp_id = ?', whereArgs: [tempId]);
  }

  /// Convert a DB row back to API-shaped map
  static Map<String, dynamic> expandConversation(Map<String, dynamic> row) {
    return {
      'id': row['id'],
      'lastMessage': row['last_message'],
      'lastMessageTime': row['last_message_time'],
      'lastMessageSender': row['last_message_sender'],
      'unreadCount': row['unread_count'],
      'status': row['status'],
      'initiatorId': row['initiator_id'],
      'participantData':
          row['participant_data'] != null ? jsonDecode(row['participant_data'] as String) : null,
      'createdAt': row['created_at'],
      'updatedAt': row['updated_at'],
    };
  }

  static Map<String, dynamic> expandMessage(Map<String, dynamic> row) {
    return {
      'id': row['id'],
      'conversationId': row['conversation_id'],
      'senderId': row['sender_id'],
      'text': row['text'],
      'timestamp': row['timestamp'],
      'read': row['read'] == 1,
      'repliedToId': row['replied_to_id'],
      'repliedToText': row['replied_to_text'],
      'messageStatus': row['message_status'],
      'createdAt': row['created_at'],
      'updatedAt': row['updated_at'],
      'senderName': row['sender_name'],
    };
  }

  static Future<T?> tryDb<T>(Future<T> Function() fn) async {
    if (kIsWeb) return null;
    try {
      return await fn();
    } on UnsupportedError {
      return null;
    }
  }

  static Future<void> tryDbVoid(Future<void> Function() fn) async {
    if (kIsWeb) return;
    try {
      await fn();
    } on UnsupportedError {
      // skip
    }
  }
}

final chatDatabaseProvider = Provider<ChatDatabase>((ref) => ChatDatabase());

// ─── Riverpod Providers ───

/// Provider for the Drift offline database instance.
final offlineDatabaseProvider = Provider<OfflineDatabase>((ref) {
  if (kIsWeb) {
    throw UnsupportedError('Drift database not available on web');
  }
  return OfflineDatabase();
});
