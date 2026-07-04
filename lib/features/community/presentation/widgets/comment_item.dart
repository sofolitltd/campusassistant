import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:campusassistant/features/community/data/models/community_comment.dart';
import 'package:campusassistant/core/di.dart';
import 'package:campusassistant/features/auth/presentation/providers/auth_provider.dart'
    show currentUserProvider;
import 'package:campusassistant/core/theme/tokens/app_radius.dart';

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
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Update your comment...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(RadiusToken.md)),
          ),
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
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = ref.watch(currentUserProvider).value;
    final isAuthor = currentUser?.id == widget.comment.authorId;

    return Padding(
      padding: EdgeInsets.only(bottom: 16, left: widget.isReply ? 40 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: widget.isReply ? 12 : 14,
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                backgroundImage: widget.comment.authorAvatar != null
                    ? NetworkImage(widget.comment.authorAvatar!)
                    : null,
                child: widget.comment.authorAvatar == null
                    ? Text(
                        widget.comment.authorName[0],
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: widget.isReply ? 8 : 10,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.comment.authorName,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.comment.content,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Row(
                        children: [
                          Text(
                            timeago.format(
                              widget.comment.createdAt,
                              locale: 'en_short',
                            ),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: _handleLike,
                            child: Text(
                              _isLiked ? 'Liked' : 'Like',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: _isLiked
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_likesCount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '$_likesCount',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => widget.onReply(
                              widget.comment.id,
                              widget.comment.authorName,
                            ),
                            child: Text(
                              'Reply',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isAuthor) ...[
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: _showEditDialog,
                              child: Text(
                                'Edit',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: _showDeleteConfirm,
                              child: Text(
                                'Delete',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.bold,
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
            ...widget.comment.replies
                .map(
                  (reply) => CommentItem(
                    comment: reply,
                    onReply: widget.onReply,
                    onRefresh: widget.onRefresh,
                    isReply: true,
                  ),
                )
                ,
        ],
      ),
    );
  }
}
