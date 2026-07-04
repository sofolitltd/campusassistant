import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class ChatDatabase {
  static Database? _instance;

  static Future<Database> get instance async {
    if (kIsWeb) throw UnsupportedError('Local database not available on web');
    if (_instance != null) return _instance!;
    final dbPath = await getDatabasesPath();
    _instance = await openDatabase(
      p.join(dbPath, 'campusassistant_chat.db'),
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _instance!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
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

  static Future<void> _createTables(Database db) async {
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
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> upsertConversations(List<Map<String, dynamic>> list) async {
    final db = await instance;
    final batch = db.batch();
    for (final json in list) {
      batch.insert('conversations', _flattenConversation(json),
          conflictAlgorithm: ConflictAlgorithm.replace);
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
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> upsertMessages(List<Map<String, dynamic>> list) async {
    final db = await instance;
    final batch = db.batch();
    for (final json in list) {
      batch.insert('messages', _flattenMessage(json),
          conflictAlgorithm: ConflictAlgorithm.replace);
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
    }, conflictAlgorithm: ConflictAlgorithm.replace);
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
      }, conflictAlgorithm: ConflictAlgorithm.replace);
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
        conflictAlgorithm: ConflictAlgorithm.replace);
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
