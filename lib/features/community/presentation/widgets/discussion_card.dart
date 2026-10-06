import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;
import 'package:timeago/timeago.dart' as timeago;

import '/core/di.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/community/data/models/community_post.dart';
import '/features/community/presentation/widgets/comments_sheet.dart';
import '/features/community/presentation/widgets/interaction_button.dart';
import '/features/community/presentation/providers/community_posts_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class DiscussionCard extends ConsumerStatefulWidget {
  final CommunityPost post;
  final String scope;

  const DiscussionCard({super.key, required this.post, required this.scope});

  @override
  ConsumerState<DiscussionCard> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends ConsumerState<DiscussionCard> {
  late bool _isLiked;
  late int _likeCount;
  bool _isBookmarked = false;
  late int _commentCount;
  late String _displayContent;

  @override
  void initState() {
    super.initState();
    _syncFromPost();
  }

  @override
  void didUpdateWidget(DiscussionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post.id != oldWidget.post.id ||
        widget.post.isLiked != oldWidget.post.isLiked ||
        widget.post.isSaved != oldWidget.post.isSaved) {
      _syncFromPost();
    }
  }

  void _syncFromPost() {
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likesCount;
    _isBookmarked = widget.post.isSaved;
    _commentCount = widget.post.commentsCount;
    _displayContent = widget.post.content;
  }

  String get _providerScope => widget.scope.toLowerCase();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: Spacing.md),
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(color: context.colors.border),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  GestureDetector(
                    onTap: () => _showAuthorDialog(context),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          backgroundImage: widget.post.authorAvatar != null
                              ? NetworkImage(
                                  ApiEndpoints.resolveImageUrl(
                                    widget.post.authorAvatar,
                                  ),
                                )
                              : null,
                          child: widget.post.authorAvatar == null
                              ? Text(
                                  widget.post.authorName[0],
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: FontSizeToken.sm,
                                    fontWeight: .bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: Spacing.md),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              widget.post.authorName,
                              style: GoogleFonts.outfit(
                                fontWeight: .w600,
                                fontSize: FontSizeToken.md,
                                color: context.colors.text,
                              ),
                            ),
                            Text(
                              '${timeago.format(widget.post.createdAt)} • ${widget.scope}',
                              style: GoogleFonts.outfit(
                                fontSize: FontSizeToken.xs,
                                color: context.colors.textSubtle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    _displayContent,
                    style: GoogleFonts.outfit(
                      fontSize: FontSizeToken.md,
                      height: 1.4,
                      color: context.colors.text,
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  if (widget.post.imageUrls.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.md),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: widget.post.imageUrls.length,
                        itemBuilder: (context, index) {
                          final url = widget.post.imageUrls[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(RadiusToken.sm),
                            child: CachedNetworkImage(
                              imageUrl: ApiEndpoints.resolveImageUrl(url),
                              fit: .cover,
                              placeholder: (_, _) =>
                                  Container(color: context.colors.border),
                              errorWidget: (_, _, _) =>
                                  const Icon(Icons.broken_image),
                            ),
                          );
                        },
                      ),
                    ),
                  Row(
                    children: [
                      InteractionButton(
                        icon: LucideIcons.messageSquare,
                        label: '$_commentCount',
                        onTap: () => _showCommentsSheet(context),
                      ),
                      const SizedBox(width: Spacing.lg),
                      InteractionButton(
                        icon: _isLiked ? Icons.favorite : LucideIcons.heart,
                        iconColor: _isLiked ? context.colors.danger : null,
                        label: '$_likeCount',
                        onTap: () async {
                          final oldIsLiked = _isLiked;
                          final oldLikeCount = _likeCount;
                          setState(() {
                            _isLiked = !_isLiked;
                            _likeCount += _isLiked ? 1 : -1;
                          });
                          try {
                            if (_isLiked) {
                              await ref
                                  .read(communityRepositoryProvider)
                                  .likePost(widget.post.id);
                            } else {
                              await ref
                                  .read(communityRepositoryProvider)
                                  .unlikePost(widget.post.id);
                              if (widget.scope == 'liked') {
                                ref
                                    .read(
                                      communityPostsProvider('liked').notifier,
                                    )
                                    .remove(widget.post.id);
                              }
                            }
                            ref
                                .read(communityRefreshProvider.notifier)
                                .increment();
                          } catch (e) {
                            setState(() {
                              _isLiked = oldIsLiked;
                              _likeCount = oldLikeCount;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: Spacing.lg),
                      InteractionButton(
                        icon: LucideIcons.bookmark,
                        iconColor: _isBookmarked
                            ? context.colors.primary
                            : null,
                        label: _isBookmarked ? 'Saved' : 'Save',
                        onTap: () async {
                          final oldIsBookmarked = _isBookmarked;
                          setState(() {
                            _isBookmarked = !_isBookmarked;
                          });
                          try {
                            if (_isBookmarked) {
                              await ref
                                  .read(communityRepositoryProvider)
                                  .savePost(widget.post.id);
                            } else {
                              await ref
                                  .read(communityRepositoryProvider)
                                  .unsavePost(widget.post.id);
                              if (widget.scope == 'saved') {
                                ref
                                    .read(
                                      communityPostsProvider('saved').notifier,
                                    )
                                    .remove(widget.post.id);
                              }
                            }
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _isBookmarked
                                      ? 'Post saved to bookmarks'
                                      : 'Post removed from bookmarks',
                                ),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            ref
                                .read(communityRefreshProvider.notifier)
                                .increment();
                          } catch (e) {
                            setState(() {
                              _isBookmarked = oldIsBookmarked;
                            });
                          }
                        },
                      ),
                      const Spacer(),
                      InteractionButton(
                        icon: LucideIcons.share,
                        onTap: () => _sharePost(context),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (ref.watch(currentUserProvider).value?.id == widget.post.authorId)
          Positioned(
            top: 0,
            right: -4,
            child: IconButton(
              icon: const Icon(LucideIcons.ellipsisVertical, size: 16),
              onPressed: () => _showOptionsMenu(context),
              padding: EdgeInsets.all(Spacing.xxs),
              constraints: const BoxConstraints(),
            ),
          ),
      ],
    );
  }

  void _showAuthorDialog(BuildContext context) {
    final post = widget.post;
    final rows = [
      if (post.authorUniversity != null) ('University', post.authorUniversity!),
      if (post.authorDepartment != null) ('Department', post.authorDepartment!),
      if (post.authorBatch != null) ('Batch', post.authorBatch!),
      if (post.authorSession != null) ('Session', post.authorSession!),
    ];
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
        backgroundColor: context.colors.surface,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            mainAxisSize: .min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.1),
                backgroundImage: post.authorAvatar != null
                    ? NetworkImage(
                        ApiEndpoints.resolveImageUrl(post.authorAvatar),
                      )
                    : null,
                child: post.authorAvatar == null
                    ? Text(
                        post.authorName.isNotEmpty ? post.authorName[0] : '',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 28,
                          fontWeight: .bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: Spacing.md),
              Text(
                post.authorName,
                style: GoogleFonts.outfit(
                  fontWeight: .w700,
                  fontSize: FontSizeToken.xl,
                  color: context.colors.text,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                '@${post.authorId.substring(0, 8)}',
                style: GoogleFonts.outfit(
                  fontSize: FontSizeToken.sm,
                  color: context.colors.textSubtle,
                ),
              ),
              const SizedBox(height: Spacing.lg),
              const Divider(height: 1),
              const SizedBox(height: Spacing.sm),
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                  child: Text(
                    'No profile details available.',
                    style: GoogleFonts.outfit(color: context.colors.textSubtle),
                  ),
                )
              else
                ...rows.map(
                  (r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Text(
                          '${r.$1}:',
                          style: GoogleFonts.outfit(
                            fontSize: FontSizeToken.md,
                            color: context.colors.textSubtle,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            r.$2,
                            style: GoogleFonts.outfit(
                              fontSize: FontSizeToken.md,
                              fontWeight: .w600,
                              color: context.colors.text,
                            ),
                            textAlign: .right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: Spacing.sm),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isOwner =
        currentUser != null && currentUser.id == widget.post.authorId;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(RadiusToken.xl),
          ),
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            const SizedBox(height: Spacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.borderStrong,
                borderRadius: BorderRadius.circular(RadiusToken.xs),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            if (isOwner) ...[
              ListTile(
                leading: const Icon(LucideIcons.pencil, size: 20),
                title: const Text(
                  'Edit Post',
                  style: TextStyle(fontSize: FontSizeToken.base),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showEditSheet(context);
                },
              ),
              ListTile(
                leading: Icon(
                  LucideIcons.trash2,
                  size: 20,
                  color: context.colors.danger,
                ),
                title: Text(
                  'Delete Post',
                  style: TextStyle(
                    fontSize: FontSizeToken.base,
                    color: context.colors.danger,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context);
                },
              ),
            ],
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
          'Are you sure you want to delete this post? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref
                    .read(communityRepositoryProvider)
                    .deletePost(widget.post.id);
                if (!context.mounted) return;
                ref
                    .read(communityPostsProvider(_providerScope).notifier)
                    .remove(widget.post.id);
                ref
                    .read(communityPostsProvider(_providerScope).notifier)
                    .fetch();
                ref.read(communityRefreshProvider.notifier).increment();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post deleted'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete post: $e'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: context.colors.danger),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    final controller = TextEditingController(text: widget.post.content);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusToken.xxl),
            ),
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                'Edit Post',
                style: GoogleFonts.outfit(
                  fontWeight: .bold,
                  fontSize: FontSizeToken.lg,
                ),
              ),
              const SizedBox(height: Spacing.md),
              TextField(
                controller: controller,
                maxLines: 5,
                minLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.colors.surfaceAlt,
                  hintText: 'Write something...',
                ),
              ),
              const SizedBox(height: Spacing.md),
              Row(
                mainAxisAlignment: .end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: Spacing.sm),
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            final content = controller.text.trim();
                            if (content.isEmpty) return;
                            setSheetState(() => isSaving = true);
                            try {
                              final updated = await ref
                                  .read(communityRepositoryProvider)
                                  .updatePost(widget.post.id, content);
                              if (!context.mounted) return;
                              setState(() {
                                _displayContent = updated.content;
                              });
                              Navigator.pop(sheetContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Post updated'),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              ref
                                  .read(
                                    communityPostsProvider(
                                      _providerScope,
                                    ).notifier,
                                  )
                                  .fetch();
                              ref
                                  .read(communityRefreshProvider.notifier)
                                  .increment();
                            } catch (e) {
                              setSheetState(() => isSaving = false);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update post: $e'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: context.colors.onPrimary,
                    ),
                    child: isSaving
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CupertinoActivityIndicator(
                              color: context.colors.onPrimary,
                            ),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(
        post: widget.post,
        onCommentAdded: () {
          setState(() {
            _commentCount++;
          });
        },
      ),
    );
  }

  Future<void> _sharePost(BuildContext context) async {
    final post = widget.post;
    final text = '${post.authorName}: ${post.content}';

    if (post.imageUrls.isEmpty) {
      await SharePlus.instance.share(
        ShareParams(text: text, subject: 'Post from ${post.authorName}'),
      );
      return;
    }

    try {
      final dio = Dio();
      final files = <XFile>[];
      for (final url in post.imageUrls) {
        final response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        final tempDir = await getTemporaryDirectory();
        final ext = url.split('.').last.split('?').first;
        final file = File(
          '${tempDir.path}/share_${post.id}_${files.length}.$ext',
        );
        await file.writeAsBytes(response.data);
        files.add(XFile(file.path));
      }
      await SharePlus.instance.share(
        ShareParams(
          files: files,
          text: text,
          subject: 'Post from ${post.authorName}',
        ),
      );
    } catch (e) {
      await SharePlus.instance.share(
        ShareParams(text: text, subject: 'Post from ${post.authorName}'),
      );
    }
  }
}
