import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Container(
              height: 36,
              margin: const EdgeInsets.only(right: Spacing.lg),
              decoration: BoxDecoration(
                color: context.colors.surfaceAlt,
                borderRadius: BorderRadius.circular(RadiusToken.md),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (v) {
                  setState(() {});
                  _loadContacts();
                },
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: FontSizeToken.lg,
                ),
                decoration: InputDecoration(
                  hintText: 'Search contacts',
                  hintStyle: TextStyle(
                    color: context.colors.textSubtle,
                    fontSize: FontSizeToken.lg,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.sm,
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    size: 18,
                    color: context.colors.textSubtle,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            LucideIcons.x,
                            size: 16,
                            color: context.colors.textSubtle,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _loadContacts();
                          },
                        )
                      : null,
                  isDense: true,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 0,
                  ),
                ),
              ),
            ),
          ),
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
                  padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
                  itemCount: _contacts.length + (_hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => Divider(
                    height: 0,
                    indent: 72,
                    color: context.colors.border,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= _contacts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(Spacing.lg),
                        child: Center(child: CupertinoActivityIndicator()),
                      );
                    }
                    final contact = _contacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            contact.avatarUrl != null &&
                                contact.avatarUrl!.isNotEmpty
                            ? NetworkImage(
                                ApiEndpoints.resolveImageUrl(contact.avatarUrl),
                              )
                            : null,
                        backgroundColor: context.colors.primary.withValues(
                          alpha: 0.2,
                        ),
                        child:
                            contact.avatarUrl == null ||
                                contact.avatarUrl!.isEmpty
                            ? Text(
                                contact.name.isNotEmpty
                                    ? contact.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: context.colors.primary,
                                  fontWeight: .bold,
                                  fontSize: FontSizeToken.lg,
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        contact.name,
                        style: const TextStyle(
                          fontWeight: .w500,
                          fontSize: FontSizeToken.lg,
                        ),
                      ),
                      onTap: () async {
                        final repo = ref.read(chatRepositoryProvider);
                        final result = await repo.getOrCreateConversation(
                          otherUserId: contact.userId,
                          otherUserName: contact.name,
                          otherUserImage:
                              contact.avatarUrl != null &&
                                  contact.avatarUrl!.isNotEmpty
                              ? contact.avatarUrl
                              : null,
                        );
                        final convId = result['id'] as String;
                        final status = result['status'] as String? ?? 'pending';
                        final initiatorId = result['initiatorId'] as String?;
                        await ChatDatabase.tryDbVoid(
                          () => ChatDatabase.upsertConversations([result]),
                        );
                        ref
                            .read(conversationsRefreshProvider.notifier)
                            .trigger();
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        context.pushNamed(
                          AppRoute.inboxChat.name,
                          pathParameters: {'conversationId': convId},
                          extra: {
                            'name': contact.name,
                            'otherUserId': contact.userId,
                            'status': status,
                            'initiatorId': initiatorId,
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
