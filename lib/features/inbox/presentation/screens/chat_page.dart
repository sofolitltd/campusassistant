import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/websocket/chat_websocket.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/inbox/data/repositories/chat_repository.dart';
import '/features/inbox/data/services/message_queue_service.dart';
import '/features/inbox/presentation/providers/chat_providers.dart';
import '/features/inbox/presentation/widgets/chat_item.dart';
import '/features/inbox/presentation/widgets/chat_input.dart';
import '/features/inbox/presentation/widgets/date_separator.dart';
import '/features/inbox/presentation/widgets/edit_banner.dart';
import '/features/inbox/presentation/widgets/menu_row.dart';
import '/features/inbox/presentation/widgets/message_bubble.dart';
import '/features/inbox/presentation/widgets/reply_banner.dart';
import '/features/inbox/presentation/widgets/select_bar.dart';
import '/core/theme/tokens/app_radius.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String conversationId;
  final String name;
  final String otherUserId;
  final String status;
  final String? initiatorId;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.name,
    required this.otherUserId,
    this.status = 'accepted',
    this.initiatorId,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _selectedMsgIds = <String>{};
  final _typingUsers = <String>{};

  bool _isSending = false;
  bool _autoScroll = true;
  bool _selectMode = false;

  String? _editingMsgId;
  String? _editingOldText;
  String? _replyingText;
  String? _replyingMsgId;
  bool _hasText = false;
  bool _isMultiline = false;

  Timer? _typingDebounce;
  ChatWebSocketService? _wsService;
  StreamSubscription<ChatWebSocketEvent>? _wsSub;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      final text = _messageController.text;
      setState(() {
        _hasText = text.isNotEmpty;
        _isMultiline = text.contains('\n');
      });
      _debounceTyping();
    });
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(conversationMessagesProvider(widget.conversationId).notifier)
          .loadInitial();
      _repo.markAsRead(widget.conversationId);
      _restoreScrollPosition();
    });
    _connectWebSocket();
  }

  @override
  void dispose() {
    if (_scrollController.hasClients) {
      ref.read(chatScrollOffsetsProvider.notifier)
          .save(widget.conversationId, _scrollController.position.pixels);
    }
    _messageController.dispose();
    _scrollController.dispose();
    _typingDebounce?.cancel();
    _wsSub?.cancel();
    _wsService?.dispose();
    super.dispose();
  }

  void _debounceTyping() {
    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(milliseconds: 500), () {
      _wsService?.sendTyping();
    });
  }

  void _restoreScrollPosition() {
    final saved = ref.read(chatScrollOffsetsProvider)[widget.conversationId];
    if (saved != null && saved > 0 && _scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final max = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(saved.clamp(0, max));
          _autoScroll = (max - saved) < 100;
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  Future<void> _connectWebSocket() async {
    final svc = ChatWebSocketService();
    await svc.connect(widget.conversationId);
    _wsSub = svc.events.listen(_handleWSEvent);
    _wsService = svc;
  }

  void _inboxRefresh() {
    unawaited(syncConversations(ref.read(chatRepositoryProvider))
        .then((_) => ref.read(conversationsRefreshProvider.notifier).trigger()));
  }

  void _handleWSEvent(ChatWebSocketEvent event) {
    if (!mounted) return;
    final notifier = ref.read(conversationMessagesProvider(widget.conversationId).notifier);
    switch (event.type) {
      case 'new_message':
        if (event.message != null) {
          final senderId = event.message!['senderId'] as String?;
          final currentId = ref.read(currentUserProvider).asData?.value?.id;
          if (senderId != currentId) {
            notifier.addMessage(event.message!);
            _autoScroll = true;
            _scrollToBottom();
            // Acknowledge delivery to sender
            _wsService?.send({
              'type': 'delivered',
              'messageId': event.message!['id'],
            });
          }
          _inboxRefresh();
        }
      case 'message_edited':
        if (event.messageId != null && event.text != null) {
          notifier.updateMessage(event.messageId!, {
            'text': event.text,
            'updated_at': DateTime.now().toIso8601String(),
          });
        }
      case 'message_delivered':
        if (event.messageId != null) {
          notifier.updateMessage(event.messageId!, {
            'messageStatus': 'delivered',
          });
        }
      case 'typing':
        if (event.userId != null) {
          setState(() {
            event.isTyping ?? true
                ? _typingUsers.add(event.userId!)
                : _typingUsers.remove(event.userId);
          });
        }
      case 'message_deleted':
        if (event.messageId != null) {
          final currentId = ref.read(currentUserProvider).asData?.value?.id;
          if (event.userId == currentId) {
            notifier.removeMessage(event.messageId!);
            _inboxRefresh();
          }
        }
      case 'mark_read':
        if (event.userId != null) {
          final currentMessages = ref.read(conversationMessagesProvider(widget.conversationId)).messages;
          for (final msg in currentMessages) {
            if (msg['senderId'] != event.userId && msg['read'] != true) {
              notifier.updateMessage(msg['id'] as String, {'read': true});
            }
          }
        }
    }
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  Future<void> _loadMoreMessages() async {
    final notifier = ref.read(conversationMessagesProvider(widget.conversationId).notifier);
    await notifier.loadMore();
  }

  void _onScroll() {
    final s = ref.read(conversationMessagesProvider(widget.conversationId));
    if (_scrollController.position.pixels <= 100 && s.hasMore && !s.loadingMore) {
      _loadMoreMessages();
    }
    if (_scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      _autoScroll = (max - current) < 100;
    }
  }

  void _scrollToBottom() {
    if (!_autoScroll || !_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _exitSelectMode() {
    setState(() {
      _selectMode = false;
      _selectedMsgIds.clear();
    });
  }

  void _toggleMessageSelection(String messageId) {
    setState(() {
      _selectedMsgIds.contains(messageId) ? _selectedMsgIds.remove(messageId) : _selectedMsgIds.add(messageId);
      if (_selectedMsgIds.isEmpty) _selectMode = false;
    });
  }

  void _deleteSelectedMessages() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1F2C33) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                  ),
                  title: Text(
                    'Delete ${_selectedMsgIds.length} messages',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final repo = ref.read(chatRepositoryProvider);
                    final notifier = ref.read(conversationMessagesProvider(widget.conversationId).notifier);
                    await Future.wait(_selectedMsgIds.map((id) =>
                        repo.deleteMessage(
                            conversationId: widget.conversationId, messageId: id)));
                    for (final id in _selectedMsgIds.toList()) {
                      notifier.deleteMessage(id);
                    }
                    _exitSelectMode();
                    _inboxRefresh();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Messages deleted')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _cancelEdit() {
    setState(() {
      _editingMsgId = null;
      _editingOldText = null;
    });
    _messageController.clear();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    final editingId = _editingMsgId;
    final replyingId = _replyingMsgId;
    final replyingText = _replyingText;
    setState(() => _isSending = true);
    _messageController.clear();
    setState(() {
      _replyingText = null;
      _replyingMsgId = null;
    });

    final notifier = ref.read(conversationMessagesProvider(widget.conversationId).notifier);

    if (editingId != null) {
      try {
        await _repo.editMessage(
          conversationId: widget.conversationId,
          messageId: editingId,
          text: text,
        );
        notifier.updateMessage(editingId, {
          'text': text,
          'updated_at': DateTime.now().toIso8601String(),
        });
        setState(() {
          _editingMsgId = null;
          _editingOldText = null;
        });
        _inboxRefresh();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to edit: $e')));
        }
      } finally {
        setState(() => _isSending = false);
      }
      return;
    }

    final senderId = ref.read(currentUserProvider).asData?.value?.id ?? '';
    final queue = ref.read(messageQueueProvider);

    // Optimistic message for the UI
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimistic = <String, dynamic>{
      'id': tempId,
      'senderId': senderId,
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
      'messageStatus': 'sending',
      'repliedToId': replyingId,
      'repliedToText': replyingText,
    };
    notifier.addMessage(optimistic);
    _autoScroll = true;
    _scrollToBottom();

    // Enqueue and await result
    final result = await queue.enqueue(
      conversationId: widget.conversationId,
      senderId: senderId,
      text: text,
      messageId: tempId,
      repliedToId: replyingId,
      repliedToText: replyingText,
    );

    if (result != null && result['id'] != null) {
      notifier.replaceMessage(tempId, result);
    }
    _inboxRefresh();
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(currentUserProvider);
    final s = ref.watch(conversationMessagesProvider(widget.conversationId));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111B21) : Colors.grey.shade50,
      appBar: _selectMode ? _selectAppBar(isDark) : _chatAppBar(isDark),
      body: Column(
        children: [
          Expanded(
            child: s.initialLoading
                ? const Center(child: CupertinoActivityIndicator())
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        final max = _scrollController.position.maxScrollExtent;
                        final current = _scrollController.position.pixels;
                        _autoScroll = (max - current) < 100;
                      }
                      return false;
                    },
                    child: _buildMessages(userAsync.asData?.value?.id, isDark, s),
                  ),
          ),
          if (s.loadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: CupertinoActivityIndicator(),
            ),
          if (_selectMode)
            SelectBar(
              count: _selectedMsgIds.length,
              onDelete: _deleteSelectedMessages,
              onCancel: _exitSelectMode,
              isDark: isDark,
            ),
          if (!_selectMode && _replyingText != null)
            ReplyBanner(text: _replyingText!, onCancel: _cancelReply, isDark: isDark),
          if (!_selectMode && _editingMsgId != null)
            EditBanner(oldText: _editingOldText ?? '', onCancel: _cancelEdit, isDark: isDark),
          if (!_selectMode)
            ChatInput(
              controller: _messageController,
              isDark: isDark,
              onSend: _sendMessage,
              isSending: _isSending,
              hasText: _hasText,
              isMultiline: _isMultiline,
            ),
        ],
      ),
    );
  }

  AppBar _selectAppBar(bool isDark) => AppBar(
        backgroundColor: isDark ? const Color(0xFF1F2C33) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: _exitSelectMode),
        title: Text(
          '${_selectedMsgIds.length} selected',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      );

  AppBar _chatAppBar(bool isDark) => AppBar(
        backgroundColor: isDark ? const Color(0xFF1F2C33) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.teal.withValues(alpha: 0.2),
              child: Text(
                widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                if (_typingUsers.isNotEmpty)
                  const Text(
                    'typing...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.teal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, size: 22), onPressed: () {}),
        ],
      );

  Widget _buildMessages(String? userId, bool isDark, ConversationMessagesState s) {
    final messages = s.messages;
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.messageCircle, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'No messages yet',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Send a message to start chatting',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final items = <ChatItem>[];
    String? lastDate;
    for (final msg in messages) {
      final timestamp = msg['timestamp'] as String?;
      final dateStr = timestamp != null && timestamp.length >= 10 ? timestamp.substring(0, 10) : '';
      if (dateStr.isNotEmpty && dateStr != lastDate) {
        items.add(ChatItem(kind: ItemKind.date, date: dateStr));
        lastDate = dateStr;
      }
      items.add(ChatItem(kind: ItemKind.message, data: msg));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item.kind == ItemKind.date) {
          return DateSeparator(date: _formatDateLabel(item.date!), isDark: isDark);
        }

        final msg = item.data!;
        final isMe = msg['senderId'] == userId;
        final text = msg['text'] as String? ?? '';
        final timestamp = msg['timestamp'] as String? ?? '';
        final timeStr = _formatTime(timestamp);
        final isRead = msg['read'] == true;
        final prevItem = index > 0 ? items[index - 1] : null;
        final showAvatar = prevItem == null ||
            prevItem.kind == ItemKind.date ||
            (prevItem.data?['senderId'] != msg['senderId']);

        final createdAt = msg['created_at'] as String?;
        final updatedAt = msg['updated_at'] as String?;
        final isEdited = createdAt != null && updatedAt != null && createdAt != updatedAt;

        final repliedToId = msg['repliedToId'] as String?;
        final repliedToText = msg['repliedToText'] as String?;
        final replyTargetIdx = repliedToId != null
            ? items.indexWhere(
                (item) => item.kind == ItemKind.message && item.data?['id'] == repliedToId)
            : -1;
        final msgId = msg['id'] as String;
        final isSelected = _selectedMsgIds.contains(msgId);
        final messageStatus = msg['messageStatus'] as String?;

        return MessageBubble(
          text: text,
          time: timeStr,
          isMe: isMe,
          isRead: isRead,
          isDark: isDark,
          showAvatar: showAvatar,
          senderName: isMe ? 'You' : widget.name,
          isEdited: isEdited,
          messageStatus: messageStatus,
          repliedToId: repliedToId,
          repliedToText: repliedToText,
          selectMode: _selectMode,
          isSelected: isSelected,
          onTap: _selectMode ? () => _toggleMessageSelection(msgId) : null,
          onTapReply: replyTargetIdx >= 0
              ? () {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      (replyTargetIdx * 72.0).clamp(0, _scrollController.position.maxScrollExtent),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                }
              : null,
          onLongPress: _selectMode ? null : (ctx) => _showMessageActions(ctx, msg, isMe),
          onSwipeReply: () => _replyToMessage(msg),
          onTapRetry: messageStatus == 'failed' && isMe
              ? () => _retryMessage(msg, text)
              : null,
        );
      },
    );
  }

  void _showMessageActions(BuildContext ctx, Map<String, dynamic> msg, bool isMe) {
    final text = msg['text'] as String? ?? '';
    final renderBox = ctx.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(ctx).size.width;

    showMenu(
      context: ctx,
      position: RelativeRect.fromRect(
        isMe
            ? Rect.fromLTWH(offset.dx + size.width, offset.dy, 0, 0)
            : Rect.fromLTWH(offset.dx, offset.dy, 0, 0),
        Rect.fromLTWH(0, 0, screenWidth, 0),
      ),
      items: [
        PopupMenuItem(
          child: MenuRow(icon: LucideIcons.checkSquare, label: 'Select'),
          onTap: () => setState(() {
            _selectMode = true;
            _selectedMsgIds.add(msg['id'] as String);
          }),
        ),
        PopupMenuItem(
          child: MenuRow(icon: LucideIcons.messageCircle, label: 'Reply'),
          onTap: () => _replyToMessage(msg),
        ),
        PopupMenuItem(
          child: MenuRow(icon: LucideIcons.copy, label: 'Copy'),
          onTap: () {
            Clipboard.setData(ClipboardData(text: text));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1)),
              );
            }
          },
        ),
        if (isMe)
          PopupMenuItem(
            child: MenuRow(icon: LucideIcons.pencil, label: 'Edit'),
            onTap: () => _editMessage(msg),
          ),
        if (isMe)
          PopupMenuItem(
            child: MenuRow(icon: LucideIcons.trash2, label: 'Delete', isDestructive: true),
            onTap: () => _deleteMessage(msg),
          ),
      ],
      color: Theme.of(ctx).brightness == Brightness.dark ? const Color(0xFF1F2C33) : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusToken.md)),
    );
  }

  void _replyToMessage(Map<String, dynamic> msg) {
    setState(() {
      _replyingText = msg['text'] as String?;
      _replyingMsgId = msg['id'] as String?;
    });
  }

  void _retryMessage(Map<String, dynamic> msg, String text) {
    final msgId = msg['id'] as String;
    final notifier = ref.read(conversationMessagesProvider(widget.conversationId).notifier);
    notifier.retryMessage(msgId, {'messageStatus': 'sending'});
    ref.read(messageQueueProvider).retry(msgId).then((result) {
      if (result != null && result['id'] != null) {
        notifier.replaceMessage(msgId, result);
        _inboxRefresh();
      } else {
        notifier.retryMessage(msgId, {'messageStatus': 'failed'});
      }
    });
  }

  void _cancelReply() => setState(() {
        _replyingText = null;
        _replyingMsgId = null;
      });

  void _editMessage(Map<String, dynamic> msg) {
    setState(() {
      _editingMsgId = msg['id'] as String?;
      _editingOldText = msg['text'] as String?;
    });
    _messageController.text = msg['text'] as String? ?? '';
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
  }

  void _deleteMessage(Map<String, dynamic> msg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1F2C33) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                  ),
                  title: Text(
                    'Delete for me',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    final msgId = msg['id'] as String;
                    Navigator.pop(ctx);
                    try {
                      await ref.read(chatRepositoryProvider).deleteMessage(
                        conversationId: widget.conversationId,
                        messageId: msgId,
                      );
                      ref.read(conversationMessagesProvider(widget.conversationId).notifier)
                          .deleteMessage(msgId);
                      _inboxRefresh();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Message deleted')),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to delete: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null || dt.year < 2000) return '';
    return DateFormat('h:mm a').format(dt);
  }

  String _formatDateLabel(String dateStr) {
    final now = DateTime.now();
    final date = DateTime.tryParse(dateStr);
    if (date == null || date.year < 2000) return 'Today';
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(date);
  }
}
