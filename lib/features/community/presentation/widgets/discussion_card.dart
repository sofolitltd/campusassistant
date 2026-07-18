import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import '/core/di.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/community/data/models/community_post.dart';
import '/features/community/presentation/widgets/comments_sheet.dart';
import '/features/community/presentation/widgets/interaction_button.dart';
import '/features/community/presentation/widgets/share_option.dart';
import '/core/theme/tokens/app_radius.dart';

class DiscussionCard extends ConsumerStatefulWidget {
  final CommunityPost post;
  final String scope;
  final VoidCallback? onRemoved;

  const DiscussionCard({
    super.key,
    required this.post,
    required this.scope,
    this.onRemoved,
  });

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
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likesCount;
    _isBookmarked = widget.post.isSaved;
    _commentCount = widget.post.commentsCount;
    _displayContent = widget.post.content;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                          ? NetworkImage(widget.post.authorAvatar!)
                          : null,
                      child: widget.post.authorAvatar == null
                          ? Text(
                              widget.post.authorName[0],
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.authorName,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          '${timeago.format(widget.post.createdAt)} • ${widget.scope}',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (ref.watch(currentUserProvider).value?.id == widget.post.authorId)
                IconButton(
                  icon: const Icon(LucideIcons.ellipsisVertical, size: 16),
                  onPressed: () => _showOptionsMenu(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _displayContent,
            style: GoogleFonts.outfit(
              fontSize: 13,
              height: 1.4,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          if (widget.post.imageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: isDark
                            ? Colors.white10
                            : Colors.grey.shade200,
                      ),
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
              const SizedBox(width: 16),
              InteractionButton(
                icon: _isLiked ? Icons.favorite : LucideIcons.heart,
                iconColor: _isLiked ? Colors.red : null,
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
                      // On the Liked page, an unliked post must leave the list.
                      if (!_isLiked && widget.scope == 'liked') {
                        widget.onRemoved?.call();
                      }
                    }
                  } catch (e) {
                    setState(() {
                      _isLiked = oldIsLiked;
                      _likeCount = oldLikeCount;
                    });
                  }
                },
              ),
              const SizedBox(width: 16),
              InteractionButton(
                icon: LucideIcons.bookmark,
                iconColor: _isBookmarked ? Colors.teal : null,
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
                    // On the Saved page, an unsaved post must leave the list.
                    if (!_isBookmarked && widget.scope == 'saved') {
                      widget.onRemoved?.call();
                    }
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
                label: 'Share',
                onTap: () => _showShareSheet(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAuthorDialog(BuildContext context) {
    final post = widget.post;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rows = [
      if (post.authorUniversity != null)
        ('University', post.authorUniversity!),
      if (post.authorDepartment != null)
        ('Department', post.authorDepartment!),
      if (post.authorBatch != null) ('Batch', post.authorBatch!),
      if (post.authorSession != null) ('Session', post.authorSession!),
    ];
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                backgroundImage: post.authorAvatar != null
                    ? NetworkImage(post.authorAvatar!)
                    : null,
                child: post.authorAvatar == null
                    ? Text(
                        post.authorName.isNotEmpty
                            ? post.authorName[0]
                            : '',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                post.authorName,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@${post.authorId.substring(0, 8)}',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 8),
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No profile details available.',
                    style: GoogleFonts.outfit(color: Colors.grey),
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
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            r.$2,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = ref.watch(currentUserProvider).value;
    final isOwner = currentUser != null && currentUser.id == widget.post.authorId;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            if (isOwner) ...[
              ListTile(
                leading: const Icon(LucideIcons.pencil, size: 20),
                title: const Text('Edit Post', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  _showEditSheet(context);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.trash2, size: 20, color: Colors.red),
                title: const Text(
                  'Delete Post',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context);
                },
              ),
            ],
            const SizedBox(height: 20),
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
        content: const Text('Are you sure you want to delete this post? This cannot be undone.'),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post deleted'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                              ref.read(communityRefreshProvider.notifier).increment();
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
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    final controller = TextEditingController(text: widget.post.content);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Container(
          decoration: BoxDecoration(
            color: isDark ? Theme.of(context).cardColor : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Post',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 5,
                minLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Write something...',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
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
                ref.read(communityRefreshProvider.notifier).increment();
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
                      foregroundColor: Colors.white,
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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

  void _showShareSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Post',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ShareOption(
                    icon: LucideIcons.link,
                    label: 'Copy Link',
                    color: Colors.blue,
                    onTap: () => Navigator.pop(context),
                  ),
                  ShareOption(
                    icon: LucideIcons.send,
                    label: 'Messenger',
                    color: Colors.blueAccent,
                    onTap: () => Navigator.pop(context),
                  ),
                  ShareOption(
                    icon: LucideIcons.messageCircle,
                    label: 'WhatsApp',
                    color: Colors.green,
                    onTap: () => Navigator.pop(context),
                  ),
                  ShareOption(
                    icon: LucideIcons.link,
                    label: 'Facebook',
                    color: Colors.indigo,
                    onTap: () => Navigator.pop(context),
                  ),
                  ShareOption(
                    icon: LucideIcons.link,
                    label: 'Twitter',
                    color: Colors.lightBlue,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            ListTile(
              leading: const Icon(LucideIcons.download, size: 20),
              title: const Text(
                'Save as Image',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(LucideIcons.externalLink, size: 20),
              title: const Text('Other Apps', style: TextStyle(fontSize: 14)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
