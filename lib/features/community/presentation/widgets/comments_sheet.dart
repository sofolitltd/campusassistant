import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/features/community/data/models/community_comment.dart';
import '/features/community/data/models/community_post.dart';
import '/features/community/presentation/widgets/comment_item.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: Spacing.md),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.borderStrong,
              borderRadius: BorderRadius.circular(RadiusToken.xs),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Text(
              'Comments',
              style: GoogleFonts.outfit(
                fontWeight: .bold,
                fontSize: FontSizeToken.lg,
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
                      style: GoogleFonts.outfit(
                        color: context.colors.textSubtle,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(Spacing.lg),
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
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.lg,
                vertical: Spacing.sm,
              ),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Text(
                    'Replying to $_replyingToName',
                    style: GoogleFonts.outfit(
                      fontSize: FontSizeToken.sm,
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
            color: context.colors.surface,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceAlt,
                      borderRadius: BorderRadius.circular(RadiusToken.xxxl),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.outfit(fontSize: FontSizeToken.base),
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: GoogleFonts.outfit(
                          color: context.colors.textSubtle,
                          fontSize: FontSizeToken.base,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: Spacing.md,
                        ),
                      ),
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
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
