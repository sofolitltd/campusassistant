import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/features/community/data/models/community_comment.dart';
import '/features/community/data/models/community_post.dart';
import '/features/community/presentation/widgets/comment_item.dart';

class CommentsSheet extends ConsumerStatefulWidget {
  final CommunityPost post;
  final VoidCallback? onCommentAdded;

  const CommentsSheet({super.key, required this.post, this.onCommentAdded});

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  String? _replyingToId;
  String? _replyingToName;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onReply(String commentId, String authorName) {
    setState(() {
      _replyingToId = commentId;
      _replyingToName = authorName;
    });
  }

  Future<void> _submitComment() async {
    if (_controller.text.isEmpty) return;

    final content = _controller.text.trim();
    _controller.clear();
    final parentId = _replyingToId;

    setState(() {
      _replyingToId = null;
      _replyingToName = null;
    });

    try {
      await ref
          .read(communityRepositoryProvider)
          .addComment(widget.post.id, content, parentId: parentId);
      widget.onCommentAdded?.call();
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to post comment: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Comments',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<CommunityComment>>(
              future: ref
                  .read(communityRepositoryProvider)
                  .getComments(widget.post.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return Center(
                    child: Text(
                      'No comments yet. Be the first to reply!',
                      style: GoogleFonts.outfit(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentItem(
                      comment: comments[index],
                      onReply: _onReply,
                      onRefresh: () => setState(() {}),
                      isReply: false,
                    );
                  },
                );
              },
            ),
          ),
          if (_replyingToName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Text(
                    'Replying to $_replyingToName',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() {
                      _replyingToId = null;
                      _replyingToName = null;
                    }),
                    child: Icon(
                      LucideIcons.x,
                      size: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              8 + MediaQuery.of(context).viewInsets.bottom,
            ),
            color: isDark ? Theme.of(context).cardColor : Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.outfit(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: GoogleFonts.outfit(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    LucideIcons.send,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  onPressed: _submitComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
