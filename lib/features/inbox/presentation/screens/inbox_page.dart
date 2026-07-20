import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/database/app_database.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/inbox/data/services/message_queue_service.dart';
import '/features/inbox/presentation/providers/chat_providers.dart';
import '/routes/app_route.dart';
import '/routes/scaffold_with_navbar.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';

class InboxPage extends ConsumerStatefulWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends ConsumerState<InboxPage>
    with WidgetsBindingObserver {
  final _searchController = TextEditingController();
  String _filterText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSync();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_performSync());
    }
  }

  Future<void> _performSync() async {
    try {
      await syncConversations(ref.read(chatRepositoryProvider));
      ref.read(conversationsRefreshProvider.notifier).trigger();
    } catch (_) {}
    ref.read(messageQueueProvider).retryAll();
  }

  String _timeAgo(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7}w ago';
    return '${diff.inDays ~/ 30}mo ago';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final conversationsAsync = ref.watch(conversationsProvider);
    final primaryColor = Theme.of(context).appColors.primaryColor;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () =>
                  ScaffoldWithNavBar.scaffoldKey.currentState?.openDrawer(),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
        title: Text(
          'Inbox',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(isDark),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).scaffoldBackgroundColor
                    : const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: conversationsAsync.when(
                      data: (conversations) =>
                          _buildConversationList(conversations, isDark),
                      loading: () => _buildLoading(),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoute.newChat.name),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CupertinoActivityIndicator());
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                LucideIcons.search,
                size: 20,
                color: Colors.grey.shade400,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            suffixIcon: _filterText.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _filterText = '');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        LucideIcons.circleX,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(maxHeight: 32),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onChanged: (v) => setState(() => _filterText = v),
        ),
      ),
    );
  }

  Widget _buildConversationList(
    List<Map<String, dynamic>> conversations,
    bool isDark,
  ) {
    final userId = ref.watch(currentUserProvider).asData?.value?.id;

    final filtered = _filterText.isEmpty
        ? conversations
        : conversations.where((c) {
            final data = c['participantData'] as Map<String, dynamic>? ?? {};
            final otherName =
                data.entries
                        .firstWhere(
                          (e) => e.key != userId,
                          orElse: () => MapEntry('', {'name': ''}),
                        )
                        .value['name']
                    as String? ??
                '';
            return otherName.toLowerCase().contains(_filterText.toLowerCase());
          }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          _filterText.isNotEmpty
              ? 'No conversations found'
              : 'No conversations yet',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final conv = filtered[index];
        final convId = conv['id'] as String;
        final participantData =
            conv['participantData'] as Map<String, dynamic>? ?? {};
        final otherEntry = participantData.entries.firstWhere(
          (e) => e.key != userId,
          orElse: () => MapEntry('', const {'name': 'Unknown'}),
        );
        final otherName = otherEntry.value['name'] as String? ?? 'Unknown';
        final otherImage = otherEntry.value['image'] as String? ?? '';
        final lastMessage = conv['lastMessage'] as String? ?? '';
        final lastMessageTime = conv['lastMessageTime'] as String? ?? '';
        final lastMessageSender = conv['lastMessageSender'] as String? ?? '';
        final isSentByMe = lastMessageSender == userId;
        final unreadCount = conv['unreadCount'] as int? ?? 0;
        final timeAgo = _timeAgo(lastMessageTime);
        final status = conv['status'] as String? ?? 'accepted';
        final initiatorId = conv['initiatorId'] as String?;
        final isPending = status == 'pending' && initiatorId != userId;

        return _ConversationTile(
          convId: convId,
          name: otherName,
          imageUrl: otherImage,
          lastMessage: lastMessage,
          time: timeAgo,
          isSentByMe: isSentByMe,
          isDark: isDark,
          otherUserId: otherEntry.key,
          unreadCount: unreadCount,
          isPending: isPending,
          status: status,
          initiatorId: initiatorId,
          onLongPress: () => _showConversationActions(
            context,
            convId,
            otherName,
            otherEntry.key,
            isDark,
          ),
        );
      },
    );
  }

  void _showConversationActions(
    BuildContext ctx,
    String convId,
    String name,
    String otherUserId,
    bool isDark,
  ) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: ctx,
      backgroundColor: cs.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) {
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
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      LucideIcons.archive,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ),
                  title: const Text('Archive'),
                  onTap: () async {
                    Navigator.pop(sheetCtx);
                    try {
                      await ref
                          .read(chatRepositoryProvider)
                          .archiveConversation(convId);
                      await ChatDatabase.tryDbVoid(
                        () => ChatDatabase.deleteConversation(convId),
                      );
                      ref.read(conversationsRefreshProvider.notifier).trigger();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Conversation archived'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to archive: $e')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                  title: const Text('Delete chat'),
                  onTap: () async {
                    Navigator.pop(sheetCtx);

                    // Show loading indicator
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CupertinoActivityIndicator()),
                    );

                    try {
                      await ref
                          .read(chatRepositoryProvider)
                          .deleteConversation(convId);
                      await ChatDatabase.tryDbVoid(
                        () => ChatDatabase.deleteConversation(convId),
                      );
                      ref.read(conversationsRefreshProvider.notifier).trigger();
                      if (!mounted) return;
                      Navigator.of(context).pop(); // dismiss loading
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chat deleted'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      Navigator.of(context).pop(); // dismiss loading
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete: $e')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      LucideIcons.ban,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                  title: const Text('Block'),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    final repo = ref.read(chatRepositoryProvider);
                    unawaited(repo.blockRequest(convId));
                    ref.read(conversationsRefreshProvider.notifier).trigger();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User blocked'),
                        duration: Duration(seconds: 2),
                      ),
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
}

class _ConversationTile extends StatelessWidget {
  final String convId;
  final String name;
  final String imageUrl;
  final String lastMessage;
  final String time;
  final bool isSentByMe;
  final bool isDark;
  final String otherUserId;
  final int unreadCount;
  final bool isPending;
  final String status;
  final String? initiatorId;
  final VoidCallback? onLongPress;

  const _ConversationTile({
    required this.convId,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.time,
    required this.isSentByMe,
    required this.isDark,
    required this.otherUserId,
    required this.unreadCount,
    this.isPending = false,
    this.status = 'accepted',
    this.initiatorId,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: () {
          if (isPending) {
            context.pushNamed(
              AppRoute.requestConfirmation.name,
              pathParameters: {'conversationId': convId},
              extra: {
                'name': name,
                'otherUserId': otherUserId,
                'initiatorId': initiatorId,
              },
            );
          } else {
            context.pushNamed(
              AppRoute.inboxChat.name,
              pathParameters: {'conversationId': convId},
              extra: {
                'name': name,
                'otherUserId': otherUserId,
                'status': status,
                'initiatorId': initiatorId,
              },
            );
          }
        },
        onLongPress: onLongPress,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? Theme.of(context).cardColor : Colors.white,
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(
              color: isPending
                  ? Colors.orange.shade300
                  : (isDark ? Colors.white10 : Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(ApiEndpoints.resolveImageUrl(imageUrl))
                    : null,
                backgroundColor: isPending
                    ? Colors.orange.withValues(alpha: 0.2)
                    : Colors.teal.withValues(alpha: 0.2),
                child: imageUrl.isEmpty
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: isPending ? Colors.orange : Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontWeight: unreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (time.isNotEmpty)
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 11,
                              color: unreadCount > 0
                                  ? Colors.teal
                                  : Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (isPending)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              LucideIcons.mailQuestion,
                              size: 14,
                              color: Colors.orange,
                            ),
                          )
                        else if (isSentByMe)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.done_all,
                              size: 14,
                              color: Colors.teal,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            lastMessage.isNotEmpty
                                ? (isSentByMe
                                      ? 'You: $lastMessage'
                                      : lastMessage)
                                : (isSentByMe ? 'You: ' : ''),
                            style: TextStyle(
                              fontSize: 13,
                              color: unreadCount > 0
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : Colors.grey.shade600,
                              fontWeight: unreadCount > 0
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
