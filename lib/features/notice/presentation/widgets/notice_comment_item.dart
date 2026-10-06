import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/notice_comment_model.dart';
import '../providers/notice_provider.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/features/auth/presentation/providers/auth_provider.dart'
    show currentUserProvider;
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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
            style: TextButton.styleFrom(foregroundColor: context.colors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isAuthor = currentUser?.id == comment.authorId;

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.lg),
      child: Row(
        crossAxisAlignment: .start,
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
                    comment.authorName.isNotEmpty ? comment.authorName[0] : '?',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: FontSizeToken.xxs,
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
                        comment.authorName,
                        style: const TextStyle(
                          fontWeight: .bold,
                          fontSize: FontSizeToken.sm,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        comment.content,
                        style: TextStyle(
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
                        timeago.format(comment.createdAt, locale: 'en_short'),
                        style: TextStyle(
                          fontSize: FontSizeToken.xs,
                          color: context.colors.textSubtle,
                        ),
                      ),
                      if (isAuthor) ...[
                        const SizedBox(width: Spacing.lg),
                        GestureDetector(
                          onTap: () => _showDeleteConfirm(context, ref),
                          child: Text(
                            'Delete',
                            style: TextStyle(
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
    );
  }
}
