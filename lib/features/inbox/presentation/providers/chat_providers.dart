import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/database/app_database.dart';
import '/core/di.dart';
import '/features/inbox/data/repositories/chat_repository.dart';

class _ScrollOffsetsNotifier extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => {};
  void save(String conversationId, double offset) {
    state = {...state, conversationId: offset};
  }
}

final chatScrollOffsetsProvider =
    NotifierProvider<_ScrollOffsetsNotifier, Map<String, double>>(
      _ScrollOffsetsNotifier.new,
    );

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatRepository(apiClient);
});

class _RefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void trigger() => state++;
}

final conversationsRefreshProvider = NotifierProvider<_RefreshNotifier, int>(
  _RefreshNotifier.new,
);
final messagesRefreshProvider = NotifierProvider<_RefreshNotifier, int>(
  _RefreshNotifier.new,
);

/// Fetch conversations from network and upsert into local DB.
Future<void> syncConversations(ChatRepository repo) async {
  final data = await repo.getConversations();
  await ChatDatabase.tryDbVoid(() => ChatDatabase.upsertConversations(data));
}

/// Delete all conversations from both local cache and server.
Future<void> deleteAllConversations(Ref ref) async {
  final repo = ref.read(chatRepositoryProvider);
  final local =
      await ChatDatabase.tryDb(() => ChatDatabase.getConversations()) ?? [];
  for (final conv in local) {
    try {
      await repo.deleteConversation(conv['id'] as String);
    } catch (_) {}
  }
  await ChatDatabase.tryDbVoid(() => ChatDatabase.clearAll());
  ref.read(conversationsRefreshProvider.notifier).trigger();
  ref.read(messagesRefreshProvider.notifier).trigger();
}

/// Fetch messages from network and upsert into local DB.
Future<List<Map<String, dynamic>>> syncMessages(
  ChatRepository repo,
  String conversationId,
) async {
  final result = await repo.getMessages(conversationId, limit: 30);
  var msgs = (result['messages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  msgs =
      await ChatDatabase.tryDb(
        () => ChatDatabase.filterDeletedMessages(msgs),
      ) ??
      msgs;
  if (msgs.isNotEmpty) {
    await ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessages(msgs));
  }
  return msgs;
}

/// Returns cached conversations from DB (instant after first load).
/// On first-ever load (empty DB) falls back to network fetch.
final conversationsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  ref.watch(conversationsRefreshProvider);

  final cached = await ChatDatabase.tryDb(
    () => ChatDatabase.getConversations(),
  );
  if (cached != null && cached.isNotEmpty) {
    return cached.map(ChatDatabase.expandConversation).toList();
  }

  final repo = ref.watch(chatRepositoryProvider);
  final data = await repo.getConversations();
  await ChatDatabase.tryDbVoid(() => ChatDatabase.upsertConversations(data));
  return data;
});

final messagesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      conversationId,
    ) async {
      ref.watch(messagesRefreshProvider);

      final cached = await ChatDatabase.tryDb(
        () => ChatDatabase.getMessages(conversationId),
      );
      if (cached != null && cached.isNotEmpty) {
        return cached.map(ChatDatabase.expandMessage).toList();
      }

      final repo = ref.watch(chatRepositoryProvider);
      final result = await repo.getMessages(conversationId, limit: 30);
      final msgs =
          (result['messages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      await ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessages(msgs));
      return msgs;
    });

class ConversationMessagesState {
  final List<Map<String, dynamic>> messages;
  final bool initialLoading;
  final bool loadingMore;
  final bool hasMore;
  final String? nextCursor;
  final String? error;

  const ConversationMessagesState({
    this.messages = const [],
    this.initialLoading = true,
    this.loadingMore = false,
    this.hasMore = true,
    this.nextCursor,
    this.error,
  });

  ConversationMessagesState copyWith({
    List<Map<String, dynamic>>? messages,
    bool? initialLoading,
    bool? loadingMore,
    bool? hasMore,
    String? nextCursor,
    String? error,
  }) {
    return ConversationMessagesState(
      messages: messages ?? this.messages,
      initialLoading: initialLoading ?? this.initialLoading,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationMessagesState &&
          runtimeType == other.runtimeType &&
          messages == other.messages &&
          initialLoading == other.initialLoading &&
          loadingMore == other.loadingMore &&
          hasMore == other.hasMore &&
          nextCursor == other.nextCursor &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
    messages,
    initialLoading,
    loadingMore,
    hasMore,
    nextCursor,
    error,
  );
}

class ConversationMessagesNotifier extends Notifier<ConversationMessagesState> {
  final String conversationId;

  ConversationMessagesNotifier(this.conversationId);

  @override
  ConversationMessagesState build() {
    return const ConversationMessagesState();
  }

  Future<void> loadInitial() async {
    if (state.messages.isNotEmpty && !state.initialLoading) return;
    state = state.copyWith(initialLoading: true);
    try {
      final cached = await ChatDatabase.tryDb(
        () => ChatDatabase.getMessages(conversationId),
      );
      if (cached != null && cached.isNotEmpty) {
        state = state.copyWith(
          messages: cached.map(ChatDatabase.expandMessage).toList(),
          initialLoading: false,
        );
        _backgroundSync();
        return;
      }

      final repo = ref.read(chatRepositoryProvider);
      final result = await repo.getMessages(conversationId, limit: 30);
      final msgs =
          (result['messages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      await ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessages(msgs));

      state = state.copyWith(
        messages: msgs,
        nextCursor: result['nextCursor'] as String?,
        hasMore: result['nextCursor'] != null,
        initialLoading: false,
      );
    } catch (e) {
      state = state.copyWith(initialLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore) return;
    state = state.copyWith(loadingMore: true);
    try {
      final repo = ref.read(chatRepositoryProvider);
      final result = await repo.getMessages(
        conversationId,
        cursor: state.nextCursor,
        limit: 30,
      );
      var msgs =
          (result['messages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      if (msgs.isNotEmpty) {
        msgs =
            await ChatDatabase.tryDb(
              () => ChatDatabase.filterDeletedMessages(msgs),
            ) ??
            msgs;
        await ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessages(msgs));
      }
      state = state.copyWith(
        messages: [...msgs, ...state.messages],
        nextCursor: result['nextCursor'] as String?,
        hasMore: result['nextCursor'] != null,
        loadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false);
    }
  }

  void addMessage(Map<String, dynamic> msg) {
    ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessage(msg));
    state = state.copyWith(messages: [...state.messages, msg]);
  }

  void removeMessage(String id) {
    ChatDatabase.tryDbVoid(() => ChatDatabase.addDeletedMessage(id));
    ChatDatabase.tryDbVoid(() => ChatDatabase.deleteMessage(id));
    state = state.copyWith(
      messages: state.messages.where((m) => m['id'] != id).toList(),
    );
  }

  void deleteMessage(String id) {
    ChatDatabase.tryDbVoid(() => ChatDatabase.addDeletedMessage(id));
    ChatDatabase.tryDbVoid(() => ChatDatabase.deleteMessage(id));
    state = state.copyWith(
      messages: state.messages.where((m) => m['id'] != id).toList(),
    );
  }

  void updateMessage(String id, Map<String, dynamic> updates) {
    state = state.copyWith(
      messages: state.messages.map((m) {
        if (m['id'] == id) {
          final merged = {...m, ...updates};
          ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessage(merged));
          return merged;
        }
        return m;
      }).toList(),
    );
  }

  void retryMessage(String id, Map<String, dynamic> updated) {
    state = state.copyWith(
      messages: state.messages.map((m) {
        if (m['id'] == id) {
          final merged = {...m, ...updated};
          ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessage(merged));
          return merged;
        }
        return m;
      }).toList(),
    );
  }

  void replaceMessage(String oldId, Map<String, dynamic> replacement) {
    final idx = state.messages.indexWhere((m) => m['id'] == oldId);
    if (idx >= 0) {
      final msgs = [...state.messages];
      msgs[idx] = replacement;
      ChatDatabase.tryDbVoid(() => ChatDatabase.deleteMessage(oldId));
      ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessage(replacement));
      state = state.copyWith(messages: msgs);
    }
  }

  Future<void> _backgroundSync() async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      final result = await repo.getMessages(conversationId, limit: 30);
      var msgs =
          (result['messages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      msgs =
          await ChatDatabase.tryDb(
            () => ChatDatabase.filterDeletedMessages(msgs),
          ) ??
          msgs;
      await ChatDatabase.tryDbVoid(() => ChatDatabase.upsertMessages(msgs));

      final serverById = {for (final m in msgs) m['id'] as String: m};
      final current = state.messages;
      final merged = current
          .map((m) => serverById.remove(m['id'] as String) ?? m)
          .toList();
      merged.addAll(serverById.values);

      merged.sort((a, b) {
        final aTime =
            a['createdAt'] as String? ?? a['timestamp'] as String? ?? '';
        final bTime =
            b['createdAt'] as String? ?? b['timestamp'] as String? ?? '';
        return aTime.compareTo(bTime);
      });

      state = state.copyWith(messages: merged);
    } catch (_) {}
  }
}

final conversationMessagesProvider =
    NotifierProvider.family<
      ConversationMessagesNotifier,
      ConversationMessagesState,
      String
    >((conversationId) => ConversationMessagesNotifier(conversationId));
