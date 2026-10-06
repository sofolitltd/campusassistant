import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import '/core/widgets/custom_header_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/core/database/app_database.dart';
import '/features/inbox/data/repositories/chat_repository.dart';
import '/features/inbox/presentation/providers/chat_providers.dart';
import '/routes/app_route.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class NewChatPage extends ConsumerStatefulWidget {
  const NewChatPage({super.key});

  @override
  ConsumerState<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends ConsumerState<NewChatPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounce;

  List<Contact> _contacts = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  static const _limit = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadContacts();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadContacts() async {
    setState(() {
      _loading = true;
      _contacts = [];
      _offset = 0;
      _hasMore = true;
    });
    try {
      final repo = ref.read(chatRepositoryProvider);
      final result = await repo.getContacts(
        limit: _limit,
        offset: 0,
        search: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
      );
      setState(() {
        _contacts = result.contacts;
        _offset = _contacts.length;
        _hasMore = _contacts.length < result.total;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final repo = ref.read(chatRepositoryProvider);
      final result = await repo.getContacts(
        limit: _limit,
        offset: _offset,
        search: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
      );
      setState(() {
        _contacts.addAll(result.contacts);
        _offset = _contacts.length;
        _hasMore = _contacts.length < result.total;
        _loadingMore = false;
      });
    } catch (_) {
      setState(() => _loadingMore = false);
    }
  }

  void _onSearchChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), _loadContacts);
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderLayout(
      glassSearch: true,
      title: 'New Chat',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: Spacing.sm),
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
      ],
      searchHint: 'Search contacts',
      controller: _searchController,
      onSearchChanged: _onSearchChanged,
      onClear: () {
        _searchDebounce?.cancel();
        _loadContacts();
      },
      body: _loading
          ? const Center(child: CupertinoActivityIndicator())
          : _contacts.isEmpty
          ? Center(
              child: Text(
                'No contacts found',
                style: TextStyle(color: context.colors.textSubtle),
              ),
            )
          : ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(Spacing.lg),
              itemCount: _contacts.length + (_hasMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
              itemBuilder: (context, index) {
                if (index >= _contacts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(Spacing.lg),
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                }
                final contact = _contacts[index];
                return _ContactCard(
                  contact: contact,
                  onTap: () => _showContactDialog(contact),
                );
              },
            ),
    );
  }

  /// Tapping a contact only opens a profile dialog; the chat is created when
  /// the user confirms with "Send message".
  Future<void> _showContactDialog(Contact contact) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => _ContactDialog(
        contact: contact,
        onSendMessage: () async {
          final route = await _createConversation(contact);
          if (route == null) return;
          // Close the dialog, then New Chat itself, then open the conversation.
          if (dialogContext.mounted) Navigator.of(dialogContext).pop();
          if (!mounted) return;
          Navigator.of(context).pop();
          context.pushNamed(
            AppRoute.inboxChat.name,
            pathParameters: {'conversationId': route.id},
            extra: route.extra,
          );
        },
      ),
    );
  }

  Future<({String id, Map<String, dynamic> extra})?> _createConversation(
    Contact contact,
  ) async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      final result = await repo.getOrCreateConversation(
        otherUserId: contact.userId,
        otherUserName: contact.name,
        otherUserImage:
            contact.avatarUrl != null && contact.avatarUrl!.isNotEmpty
            ? contact.avatarUrl
            : null,
      );
      await ChatDatabase.tryDbVoid(
        () => ChatDatabase.upsertConversations([result]),
      );
      ref.read(conversationsRefreshProvider.notifier).trigger();
      return (
        id: result['id'] as String,
        extra: <String, dynamic>{
          'name': contact.name,
          'otherUserId': contact.userId,
          'status': result['status'] as String? ?? 'pending',
          'initiatorId': result['initiatorId'] as String?,
        },
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the chat. Try again.')),
        );
      }
      return null;
    }
  }
}

class _ContactAvatar extends StatelessWidget {
  const _ContactAvatar({required this.contact, required this.radius});

  final Contact contact;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hasImage = contact.avatarUrl != null && contact.avatarUrl!.isNotEmpty;
    return CircleAvatar(
      radius: radius,
      backgroundImage: hasImage
          ? CachedNetworkImageProvider(
              ApiEndpoints.resolveImageUrl(contact.avatarUrl),
            )
          : null,
      backgroundColor: context.colors.primary.withValues(alpha: 0.2),
      child: hasImage
          ? null
          : Text(
              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
              style: TextStyle(
                color: context.colors.primary,
                fontWeight: .bold,
                fontSize: radius * 0.9,
              ),
            ),
    );
  }
}

/// Batch / session as small separate chips.
class _MetaChips extends StatelessWidget {
  const _MetaChips({required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String)>[
      if (contact.batchName?.isNotEmpty == true)
        (Icons.groups_outlined, contact.batchName!),
      if (contact.sessionName?.isNotEmpty == true)
        (Icons.calendar_today_outlined, contact.sessionName!),
    ];
    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: [
        for (final (icon, label) in items)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xxs,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceAlt,
              borderRadius: BorderRadius.circular(RadiusToken.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 11, color: context.colors.textMuted),
                const SizedBox(width: Spacing.xxs),
                Text(
                  label,
                  style: TextStyle(
                    color: context.colors.textMuted,
                    fontSize: FontSizeToken.xs,
                    fontWeight: .w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact, required this.onTap});

  final Contact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: c.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          child: Row(
            children: [
              _ContactAvatar(contact: contact, radius: 20),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      contact.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: .w600,
                        fontSize: FontSizeToken.base,
                      ),
                    ),
                    if (contact.batchName?.isNotEmpty == true ||
                        contact.sessionName?.isNotEmpty == true) ...[
                      const SizedBox(height: Spacing.xs),
                      _MetaChips(contact: contact),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: c.textSubtle),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactDialog extends StatefulWidget {
  const _ContactDialog({required this.contact, required this.onSendMessage});

  final Contact contact;
  final Future<void> Function() onSendMessage;

  @override
  State<_ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<_ContactDialog> {
  bool _sending = false;

  Future<void> _send() async {
    setState(() => _sending = true);
    await widget.onSendMessage();
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final contact = widget.contact;

    return AlertDialog(
      backgroundColor: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.xl,
              Spacing.xxl,
              Spacing.xl,
              Spacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ContactAvatar(contact: contact, radius: 36),
                const SizedBox(height: Spacing.md),
                Text(
                  contact.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: .bold,
                    fontSize: FontSizeToken.xl,
                  ),
                ),
                if (contact.batchName?.isNotEmpty == true ||
                    contact.sessionName?.isNotEmpty == true) ...[
                  const SizedBox(height: Spacing.md),
                  Center(child: _MetaChips(contact: contact)),
                ],
                const SizedBox(height: Spacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('Send message'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: Spacing.xs,
            right: Spacing.xs,
            child: IconButton(
              tooltip: 'Close',
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close, size: 20, color: c.textMuted),
              onPressed: _sending ? null : () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
