import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:campusassistant/core/di.dart';
import 'package:campusassistant/features/community/data/models/community_post.dart';
import 'package:campusassistant/features/community/presentation/widgets/comments_sheet.dart';
import 'package:campusassistant/features/community/presentation/widgets/interaction_button.dart';
import 'package:campusassistant/features/community/presentation/widgets/share_option.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';

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

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likesCount;
    _isBookmarked = widget.post.isSaved;
    _commentCount = widget.post.commentsCount;
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
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
              Expanded(
                child: Column(
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
              ),
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
            widget.post.content,
            style: GoogleFonts.outfit(
              fontSize: 13,
              height: 1.4,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              InteractionButton(
                icon: LucideIcons.messageSquare,
                label: '$_commentCount',
                onTap: () => _showCommentsSheet(context),
              ),
              const SizedBox(width: 16),
              InteractionButton(
                icon: _isLiked ? LucideIcons.heart : LucideIcons.heart,
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

  void _showOptionsMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            ListTile(
              leading: const Icon(LucideIcons.flag, size: 20),
              title: const Text('Report Post', style: TextStyle(fontSize: 14)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(LucideIcons.eyeOff, size: 20),
              title: const Text('Hide Post', style: TextStyle(fontSize: 14)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(LucideIcons.userMinus, size: 20),
              title: const Text('Mute User', style: TextStyle(fontSize: 14)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
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
              title: const Text('Save as Image', style: TextStyle(fontSize: 14)),
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
