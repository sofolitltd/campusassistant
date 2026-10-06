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
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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
    final primaryColor = context.colors.primary;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Spacing.sm),
            child: GestureDetector(
              onTap: () =>
                  ScaffoldWithNavBar.scaffoldKey.currentState?.openDrawer(),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: context.colors.surface.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(Spacing.xs),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusToken.lg),
                  child: Image.asset('assets/images/logo.png', fit: .contain),
                ),
              ),
            ),
          ),
        ],
        title: Text(
          'Inbox',
          style: GoogleFonts.outfit(
            fontWeight: .bold,
            color: context.colors.onPrimary,
            fontSize: FontSizeToken.xxl,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(isDark),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceAlt,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(RadiusToken.xxxl),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(RadiusToken.xxxl),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.xl),
        ),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CupertinoActivityIndicator());
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.xs,
        Spacing.lg,
        Spacing.xl,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontSize: FontSizeToken.lg,
            color: context.colors.text,
          ),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              color: context.colors.textSubtle,
              fontSize: FontSizeToken.lg,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: Spacing.md,
                right: Spacing.sm,
              ),
              child: Icon(
                LucideIcons.search,
                size: 20,
                color: context.colors.textSubtle,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                      ),
                      child: Icon(
                        LucideIcons.circleX,
                        size: 18,
                        color: context.colors.textSubtle,
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(maxHeight: 32),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: Spacing.lg),
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
            color: context.colors.textSubtle,
            fontSize: FontSizeToken.lg,
            fontWeight: .w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(Spacing.lg),
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xl),
        ),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
            child: Column(
              mainAxisSize: .min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: Spacing.sm),
                  decoration: BoxDecoration(
                    color: context.colors.borderStrong,
                    borderRadius: BorderRadius.circular(RadiusToken.xs),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.colors.textSubtle.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(RadiusToken.xxl),
                    ),
                    child: Icon(
                      LucideIcons.archive,
                      color: context.colors.textSubtle,
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
                      color: context.colors.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(RadiusToken.xxl),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: context.colors.danger,
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
                      color: context.colors.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(RadiusToken.xxl),
                    ),
                    child: Icon(
                      LucideIcons.ban,
                      color: context.colors.danger,
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
          margin: const EdgeInsets.only(bottom: Spacing.sm),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.md,
          ),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(
              color: isPending
                  ? context.colors.warning
                  : (context.colors.border),
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
                    ? context.colors.warning.withValues(alpha: 0.2)
                    : context.colors.primary.withValues(alpha: 0.2),
                child: imageUrl.isEmpty
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: isPending
                              ? context.colors.warning
                              : context.colors.primary,
                          fontWeight: .bold,
                          fontSize: FontSizeToken.lg,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
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
                              fontSize: FontSizeToken.base,
                            ),
                          ),
                        ),
                        if (time.isNotEmpty)
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: FontSizeToken.xs,
                              color: unreadCount > 0
                                  ? context.colors.primary
                                  : context.colors.textSubtle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Row(
                      children: [
                        if (isPending)
                          Padding(
                            padding: const EdgeInsets.only(right: Spacing.xs),
                            child: Icon(
                              LucideIcons.mailQuestion,
                              size: 14,
                              color: context.colors.warning,
                            ),
                          )
                        else if (isSentByMe)
                          Padding(
                            padding: const EdgeInsets.only(right: Spacing.xs),
                            child: Icon(
                              Icons.done_all,
                              size: 14,
                              color: context.colors.primary,
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
                              fontSize: FontSizeToken.md,
                              color: unreadCount > 0
                                  ? (context.colors.text)
                                  : context.colors.textMuted,
                              fontWeight: unreadCount > 0
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: Spacing.sm),
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                              vertical: Spacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.primary,
                              borderRadius: BorderRadius.circular(
                                RadiusToken.md,
                              ),
                            ),
                            child: Text(
                              '$unreadCount',
                              style: TextStyle(
                                color: context.colors.onPrimary,
                                fontSize: FontSizeToken.xxs,
                                fontWeight: .w600,
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
