import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/notice_comment_model.dart';
import '../providers/notice_provider.dart';
import 'notice_comment_item.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class NoticeCommentsSheet extends ConsumerStatefulWidget {
  final String noticeId;
  final VoidCallback? onCommentAdded;
  final VoidCallback? onCommentRemoved;

  const NoticeCommentsSheet({
    super.key,
    required this.noticeId,
    this.onCommentAdded,
    this.onCommentRemoved,
  });

  @override
  ConsumerState<NoticeCommentsSheet> createState() =>
      _NoticeCommentsSheetState();
}

class _NoticeCommentsSheetState extends ConsumerState<NoticeCommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<NoticeCommentModel>> _commentsFuture;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _commentsFuture = ref
        .read(noticeRepositoryProvider)
        .getComments(widget.noticeId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final content = _controller.text.trim();
    if (content.isEmpty || _sending) return;

    setState(() => _sending = true);
    try {
      await ref
          .read(noticeRepositoryProvider)
          .addComment(widget.noticeId, content);
      _controller.clear();
      widget.onCommentAdded?.call();
      setState(() {
        _commentsFuture = ref
            .read(noticeRepositoryProvider)
            .getComments(widget.noticeId);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to post comment: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _refreshComments() {
    widget.onCommentRemoved?.call();
    setState(() {
      _commentsFuture = ref
          .read(noticeRepositoryProvider)
          .getComments(widget.noticeId);
    });
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
          const Padding(
            padding: EdgeInsets.all(Spacing.lg),
            child: Text(
              'Comments',
              style: TextStyle(fontWeight: .bold, fontSize: FontSizeToken.lg),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<NoticeCommentModel>>(
              future: _commentsFuture,
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
                      style: TextStyle(color: context.colors.textSubtle),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(Spacing.lg),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return NoticeCommentItem(
                      comment: comments[index],
                      onDeleted: _refreshComments,
                    );
                  },
                );
              },
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
                      style: const TextStyle(fontSize: FontSizeToken.base),
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: TextStyle(
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
                  icon: _sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CupertinoActivityIndicator(),
                        )
                      : Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                  onPressed: _sending ? null : _submitComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
