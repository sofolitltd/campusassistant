import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/notice_comment_model.dart';
import '../providers/notice_provider.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/auth/presentation/providers/auth_provider.dart'
    show currentUserProvider;

class NoticeCommentItem extends ConsumerWidget {
  final NoticeCommentModel comment;
  final VoidCallback onDeleted;

  const NoticeCommentItem({
    super.key,
    required this.comment,
    required this.onDeleted,
  });

  void _showDeleteConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref
                    .read(noticeRepositoryProvider)
                    .deleteComment(comment.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  onDeleted();
                }
              } catch (e) {
                if (context.mounted) Navigator.pop(context);
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = ref.watch(currentUserProvider).value;
    final isAuthor = currentUser?.id == comment.authorId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Theme.of(
              context,
            ).primaryColor.withValues(alpha: 0.1),
            backgroundImage: comment.authorAvatar != null
                ? NetworkImage(
                    ApiEndpoints.resolveImageUrl(comment.authorAvatar),
                  )
                : null,
            child: comment.authorAvatar == null
                ? Text(
                    comment.authorName.isNotEmpty
                        ? comment.authorName[0]
                        : '?',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 10,
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
                        comment.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        comment.content,
                        style: TextStyle(
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
                        timeago.format(comment.createdAt, locale: 'en_short'),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      if (isAuthor) ...[
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _showDeleteConfirm(context, ref),
                          child: Text(
                            'Delete',
                            style: TextStyle(
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
    );
  }
}
