import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/database/app_database.dart';
import '/features/inbox/presentation/providers/chat_providers.dart';

final messageQueueProvider = Provider<MessageQueueService>((ref) {
  return MessageQueueService(ref);
});

class MessageQueueService {
  final Ref _ref;

  MessageQueueService(this._ref);

  /// Enqueue a message, attempt to send it, and return the server response.
  /// Returns null if the send failed (message stays in queue with 'failed' status).
  Future<Map<String, dynamic>?> enqueue({
    required String conversationId,
    required String senderId,
    required String text,
    String? messageId,
    String? repliedToId,
    String? repliedToText,
  }) async {
    final tempId =
        messageId ??
        'temp_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch & 0xFFFF}';

    // Save to outgoing queue
    await ChatDatabase.tryDbVoid(
      () => ChatDatabase.insertOutgoing({
        'temp_id': tempId,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'text': text,
        'replied_to_id': repliedToId,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      }),
    );

    // Write optimistic message to DB
    final optimistic = <String, dynamic>{
      'id': tempId,
      'conversationId': conversationId,
      'senderId': senderId,
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
      'messageStatus': 'sending',
      'repliedToId': repliedToId,
      'repliedToText': repliedToText,
    };
    ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessage(optimistic));

    // Attempt to send
    final result = await _attemptSend(
      tempId,
      conversationId,
      text,
      repliedToId,
    );

    if (result != null) {
      result['timestamp'] ??= DateTime.now().toIso8601String();
      result['repliedToText'] = repliedToText;
      ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessage(result));
      ChatDatabase.tryDbVoid(() => ChatDatabase.deleteMessage(tempId));
      await ChatDatabase.tryDbVoid(() => ChatDatabase.deleteOutgoing(tempId));
    }

    return result;
  }

  Future<Map<String, dynamic>?> _attemptSend(
    String tempId,
    String conversationId,
    String text,
    String? repliedToId,
  ) async {
    try {
      await ChatDatabase.tryDbVoid(
        () => ChatDatabase.markOutgoingStatus(tempId, 'sending'),
      );
      final repo = _ref.read(chatRepositoryProvider);
      final result = await repo.sendMessage(
        conversationId: conversationId,
        text: text,
        repliedToId: repliedToId,
      );

      if (result['id'] != null) {
        await ChatDatabase.tryDbVoid(
          () => ChatDatabase.markOutgoingStatus(tempId, 'sent'),
        );
        return result;
      }
    } catch (_) {}

    await ChatDatabase.tryDbVoid(
      () => ChatDatabase.markOutgoingStatus(tempId, 'failed'),
    );
    ChatDatabase.tryDbVoid(
      () => ChatDatabase.upsertMessage({
        'id': tempId,
        'conversationId': conversationId,
        'messageStatus': 'failed',
      }),
    );
    return null;
  }

  /// Retry a specific failed message by tempId.
  Future<Map<String, dynamic>?> retry(String tempId) async {
    final pending = await ChatDatabase.tryDb(
      () => ChatDatabase.getOutgoingPending(),
    );
    final entry = pending?.where((e) => e['temp_id'] == tempId).firstOrNull;
    if (entry == null) return null;

    return _attemptSend(
      entry['temp_id'] as String,
      entry['conversation_id'] as String,
      entry['text'] as String,
      entry['replied_to_id'] as String?,
    );
  }

  /// Retry all pending/failed messages.
  Future<void> retryAll() async {
    final pending =
        await ChatDatabase.tryDb(() => ChatDatabase.getOutgoingPending()) ?? [];
    for (final entry in pending) {
      _attemptSend(
        entry['temp_id'] as String,
        entry['conversation_id'] as String,
        entry['text'] as String,
        entry['replied_to_id'] as String?,
      );
    }
  }
}
