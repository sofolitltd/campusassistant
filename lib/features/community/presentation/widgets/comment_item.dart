import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '/features/community/data/models/community_comment.dart';
import '/core/di.dart';
import '/features/auth/presentation/providers/auth_provider.dart'
    show currentUserProvider;
import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class CommentItem extends ConsumerStatefulWidget {
  final CommunityComment comment;
  final Function(String, String) onReply;
  final VoidCallback onRefresh;
  final bool isReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onReply,
    required this.onRefresh,
    this.isReply = false,
  });

  @override
  ConsumerState<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends ConsumerState<CommentItem> {
  late bool _isLiked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.comment.isLiked;
    _likesCount = widget.comment.likesCount;
  }

  void _handleLike() {
    setState(() {
      if (_isLiked) {
        _isLiked = false;
        _likesCount--;
        ref.read(communityRepositoryProvider).unlikeComment(widget.comment.id);
      } else {
        _isLiked = true;
        _likesCount++;
        ref.read(communityRepositoryProvider).likeComment(widget.comment.id);
      }
    });
  }

  void _showEditDialog() {
    final controller = TextEditingController(text: widget.comment.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Comment',
          style: GoogleFonts.outfit(fontWeight: .bold),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(hintText: 'Update your comment...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await ref
                    .read(communityRepositoryProvider)
                    .updateComment(widget.comment.id, controller.text.trim());
                if (context.mounted) {
                  Navigator.pop(context);
                  widget.onRefresh();
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Comment',
          style: GoogleFonts.outfit(fontWeight: .bold),
        ),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(communityRepositoryProvider)
                  .deleteComment(widget.comment.id);
              if (context.mounted) {
                Navigator.pop(context);
                widget.onRefresh();
              }
            },
            style: TextButton.styleFrom(foregroundColor: context.colors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isAuthor = currentUser?.id == widget.comment.authorId;

    return Padding(
      padding: EdgeInsets.only(bottom: 16, left: widget.isReply ? 40 : 0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              CircleAvatar(
                radius: widget.isReply ? 12 : 14,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.1),
                backgroundImage: widget.comment.authorAvatar != null
                    ? NetworkImage(
                        ApiEndpoints.resolveImageUrl(
                          widget.comment.authorAvatar,
                        ),
                      )
                    : null,
                child: widget.comment.authorAvatar == null
                    ? Text(
                        widget.comment.authorName[0],
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: widget.isReply ? 8 : 10,
                          fontWeight: .bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            widget.comment.authorName,
                            style: GoogleFonts.outfit(
                              fontWeight: .bold,
                              fontSize: FontSizeToken.sm,
                            ),
                          ),
                          const SizedBox(height: Spacing.xxs),
                          Text(
                            widget.comment.content,
                            style: GoogleFonts.outfit(
                              fontSize: FontSizeToken.md,
                              color: context.colors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: Spacing.sm,
                        top: Spacing.xs,
                      ),
                      child: Row(
                        children: [
                          Text(
                            timeago.format(
                              widget.comment.createdAt,
                              locale: 'en_short',
                            ),
                            style: GoogleFonts.outfit(
                              fontSize: FontSizeToken.xs,
                              color: context.colors.textSubtle,
                            ),
                          ),
                          const SizedBox(width: Spacing.lg),
                          GestureDetector(
                            onTap: _handleLike,
                            child: Text(
                              _isLiked ? 'Liked' : 'Like',
                              style: GoogleFonts.outfit(
                                fontSize: FontSizeToken.xs,
                                color: _isLiked
                                    ? Theme.of(context).primaryColor
                                    : context.colors.textSubtle,
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                          if (_likesCount > 0) ...[
                            const SizedBox(width: Spacing.xs),
                            Text(
                              '$_likesCount',
                              style: GoogleFonts.outfit(
                                fontSize: FontSizeToken.xs,
                                color: context.colors.textSubtle,
                              ),
                            ),
                          ],
                          const SizedBox(width: Spacing.lg),
                          GestureDetector(
                            onTap: () => widget.onReply(
                              widget.comment.id,
                              widget.comment.authorName,
                            ),
                            child: Text(
                              'Reply',
                              style: GoogleFonts.outfit(
                                fontSize: FontSizeToken.xs,
                                color: context.colors.textSubtle,
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                          if (isAuthor) ...[
                            const SizedBox(width: Spacing.lg),
                            GestureDetector(
                              onTap: _showEditDialog,
                              child: Text(
                                'Edit',
                                style: GoogleFonts.outfit(
                                  fontSize: FontSizeToken.xs,
                                  color: context.colors.textSubtle,
                                  fontWeight: .bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.lg),
                            GestureDetector(
                              onTap: _showDeleteConfirm,
                              child: Text(
                                'Delete',
                                style: GoogleFonts.outfit(
                                  fontSize: FontSizeToken.xs,
                                  color: context.colors.danger,
                                  fontWeight: .bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.comment.replies.isNotEmpty)
            ...widget.comment.replies.map(
              (reply) => CommentItem(
                comment: reply,
                onReply: widget.onReply,
                onRefresh: widget.onRefresh,
                isReply: true,
              ),
            ),
        ],
      ),
    );
  }
}
