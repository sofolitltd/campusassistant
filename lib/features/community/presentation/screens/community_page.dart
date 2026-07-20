import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/widgets/section_tab_bar.dart';
import '/core/widgets/red_header_layout.dart';
import '/core/theme/app_colors.dart';
import '/routes/scaffold_with_navbar.dart';
import '/features/community/presentation/widgets/create_post_sheet.dart';
import '/features/community/presentation/widgets/discussion_card.dart';
import '/features/community/presentation/providers/community_posts_provider.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.appColors.primaryColor;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Community',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical, color: Colors.white),
            color: isDark ? theme.cardColor : Colors.white,
            onSelected: (value) {
              if (value == 'liked') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const _CommunityListScreen(
                      scope: 'liked',
                      title: 'Liked Posts',
                    ),
                  ),
                );
              } else if (value == 'saved') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const _CommunityListScreen(
                      scope: 'saved',
                      title: 'Saved Posts',
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'liked',
                child: Row(
                  children: [
                    Icon(LucideIcons.heart, size: 18),
                    SizedBox(width: 12),
                    Text('Liked Posts'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'saved',
                child: Row(
                  children: [
                    Icon(LucideIcons.bookmark, size: 18),
                    SizedBox(width: 12),
                    Text('Saved Posts'),
                  ],
                ),
              ),
            ],
          ),
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
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF8F9FA),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: SectionTabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Batch'),
                    Tab(text: 'Department'),
                    Tab(text: 'University'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _CommunityFeed(scope: 'Batch', tabIndex: 0),
                    _CommunityFeed(scope: 'Department', tabIndex: 1),
                    _CommunityFeed(scope: 'University', tabIndex: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        backgroundColor: primaryColor,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CreatePostSheet(tabIndex: _tabController.index, onPostCreated: () {}),
    );
  }
}

class _CommunityFeed extends ConsumerStatefulWidget {
  final String scope;
  final int tabIndex;

  const _CommunityFeed({required this.scope, required this.tabIndex});

  @override
  ConsumerState<_CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends ConsumerState<_CommunityFeed> {
  int _prevRefresh = 0;

  @override
  void initState() {
    super.initState();
    ref.read(communityPostsProvider(widget.scope.toLowerCase()).notifier).fetch();
  }

  @override
  Widget build(BuildContext context) {
    final refresh = ref.watch(communityRefreshProvider);
    if (refresh != _prevRefresh) {
      _prevRefresh = refresh;
      Future.microtask(() => ref.read(
        communityPostsProvider(widget.scope.toLowerCase()).notifier,
      ).fetch());
    }
    final posts = ref.watch(communityPostsProvider(widget.scope.toLowerCase()));
    return RefreshIndicator(
      onRefresh: () => ref.read(communityPostsProvider(widget.scope.toLowerCase()).notifier).fetch(),
      child: Column(
        children: [
          Expanded(
            child: posts.isEmpty
                ? Center(
                    child: Text(
                      'No discussions in ${widget.scope} yet.',
                      style: GoogleFonts.outfit(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return DiscussionCard(
                        post: posts[index],
                        scope: widget.scope,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CommunityListScreen extends ConsumerStatefulWidget {
  final String scope;
  final String title;

  const _CommunityListScreen({required this.scope, required this.title});

  @override
  ConsumerState<_CommunityListScreen> createState() =>
      _CommunityListScreenState();
}

class _CommunityListScreenState extends ConsumerState<_CommunityListScreen> {
  int _prevRefresh = 0;

  @override
  void initState() {
    super.initState();
    final scope = widget.scope == 'liked' ? 'liked' : 'saved';
    ref.read(communityPostsProvider(scope).notifier).fetch();
  }

  @override
  Widget build(BuildContext context) {
    final scope = widget.scope == 'liked' ? 'liked' : 'saved';
    final refresh = ref.watch(communityRefreshProvider);
    if (refresh != _prevRefresh) {
      _prevRefresh = refresh;
      Future.microtask(() => ref.read(
        communityPostsProvider(scope).notifier,
      ).fetch());
    }
    final posts = ref.watch(communityPostsProvider(scope));
    return RedHeaderLayout(
      title: widget.title,
      showSearchBar: false,
      body: RefreshIndicator(
        onRefresh: () => ref.read(communityPostsProvider(scope).notifier).fetch(),
        child: posts.isEmpty
            ? Center(
                child: Text(
                  'No ${widget.scope} posts yet.',
                  style: GoogleFonts.outfit(color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: posts.length,
                itemBuilder: (context, index) => DiscussionCard(
                  post: posts[index],
                  scope: widget.scope,
                ),
              ),
      ),
    );
  }
}
