import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/features/community/data/models/community_post.dart';
import '/core/widgets/pill_tab_bar.dart';
import '/features/community/presentation/widgets/create_post_sheet.dart';
import '/features/community/presentation/widgets/discussion_card.dart';

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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Community',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          PillTabBar(
            controller: _tabController,
            labels: const ['Batch', 'Department', 'University', 'Saved'],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _CommunityFeed(scope: 'Batch', tabIndex: 0),
                _CommunityFeed(scope: 'Department', tabIndex: 1),
                _CommunityFeed(scope: 'University', tabIndex: 2),
                _CommunityFeed(scope: 'Saved', tabIndex: 3),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(),
        child: const Icon(LucideIcons.plus),
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
  List<CommunityPost> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      setState(() => _isLoading = true);
      final posts = await ref
          .read(communityRepositoryProvider)
          .getPosts(widget.scope.toLowerCase());
      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(communityRefreshProvider, (_, _) => _fetchPosts());
    return RefreshIndicator(
      onRefresh: _fetchPosts,
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : _error != null
                ? Center(child: Text('Error: $_error'))
                : _posts.isEmpty
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
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      return DiscussionCard(
                        post: _posts[index],
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
