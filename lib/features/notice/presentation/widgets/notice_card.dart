import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '../../data/models/notice_model.dart';
import '../providers/notice_provider.dart';
import 'notice_comments_sheet.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/routes/app_route.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

void _openImage(BuildContext context, NoticeModel notice, String rawImage) {
  context.pushNamed(
    AppRoute.imageViewer.name,
    queryParameters: {
      'title': notice.uploader,
      'time': _formatExact(notice.time),
      'image': rawImage,
    },
  );
}

Future<void> _shareNotice(NoticeModel notice) async {
  final text = '${notice.uploader}: ${notice.message}';
  await SharePlus.instance.share(
    ShareParams(text: text, subject: 'Notice from ${notice.uploader}'),
  );
}

String _formatExact(String dateString) {
  if (dateString.isEmpty) return '';
  try {
    return DateFormat(
      'd MMM yyyy • h:mm a',
    ).format(DateTime.parse(dateString).toLocal());
  } catch (_) {
    return dateString;
  }
}

/// Shows the notice's full text/images in a bottom sheet and records a view.
/// Self-contained so [NoticeCard] can call it directly without any external
/// wiring from the page that hosts the card.
void showNoticeDetails(
  BuildContext context,
  WidgetRef ref,
  NoticeModel notice,
) {
  if (notice.id.isNotEmpty) {
    ref.read(noticeRepositoryProvider).viewNotice(notice.id).catchError((_) {});
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(RadiusToken.xxxl),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(
                Spacing.xl,
                Spacing.md,
                Spacing.xl,
                Spacing.xxxl,
              ),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: Spacing.xl),
                    decoration: BoxDecoration(
                      color: context.colors.borderStrong,
                      borderRadius: BorderRadius.circular(RadiusToken.xs),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).appColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                      ),
                      child: Icon(
                        LucideIcons.megaphone,
                        size: 22,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            notice.uploader,
                            style: TextStyle(
                              fontWeight: .w700,
                              fontSize: FontSizeToken.lg,
                              color: context.colors.text,
                            ),
                          ),
                          const SizedBox(height: Spacing.xxs),
                          Text(
                            _formatExact(notice.time),
                            style: TextStyle(
                              fontSize: FontSizeToken.sm,
                              color: context.colors.textSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xl),
                Text(
                  notice.message,
                  style: TextStyle(
                    fontSize: FontSizeToken.base,
                    height: 1.5,
                    color: context.colors.text,
                  ),
                ),
                if (notice.imageUrl.isNotEmpty) ...[
                  const SizedBox(height: Spacing.xl),
                  ...notice.imageUrl.map(
                    (url) => Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.md),
                      child: GestureDetector(
                        onTap: () => _openImage(context, notice, url),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(RadiusToken.sm),
                          child: Image.network(
                            ApiEndpoints.resolveImageUrl(url),
                            width: double.infinity,
                            fit: .cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 160,
                              color: context.colors.border,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      );
    },
  );
}

/// A single notice — public, drop-in card. Tap opens the full notice detail
/// sheet ([showNoticeDetails]); also handles like/comment/share and its own
/// like/comment count state. Used by both `DepartmentNoticesPage` and the
/// global search results page.
class NoticeCard extends ConsumerStatefulWidget {
  final NoticeModel notice;

  const NoticeCard({super.key, required this.notice});

  @override
  ConsumerState<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends ConsumerState<NoticeCard> {
  late bool _isLiked;
  late int _likeCount;
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _syncFromNotice();
  }

  @override
  void didUpdateWidget(NoticeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notice.id != oldWidget.notice.id ||
        widget.notice.isLiked != oldWidget.notice.isLiked) {
      _syncFromNotice();
    }
  }

  void _syncFromNotice() {
    _isLiked = widget.notice.isLiked;
    _likeCount = widget.notice.likesCount;
    _commentCount = widget.notice.commentsCount;
  }

  Future<void> _toggleLike() async {
    final oldIsLiked = _isLiked;
    final oldLikeCount = _likeCount;
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    try {
      if (_isLiked) {
        await ref.read(noticeRepositoryProvider).likeNotice(widget.notice.id);
      } else {
        await ref.read(noticeRepositoryProvider).unlikeNotice(widget.notice.id);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLiked = oldIsLiked;
          _likeCount = oldLikeCount;
        });
      }
    }
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoticeCommentsSheet(
        noticeId: widget.notice.id,
        onCommentAdded: () => setState(() => _commentCount++),
        onCommentRemoved: () => setState(() => _commentCount--),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notice = widget.notice;

    return GestureDetector(
      onTap: () => showNoticeDetails(context, ref, notice),
      child: Container(
        margin: const EdgeInsets.only(bottom: Spacing.md),
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              crossAxisAlignment: .start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).appColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(RadiusToken.sm),
                  ),
                  child: Icon(
                    LucideIcons.megaphone,
                    size: 20,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        notice.uploader,
                        style: TextStyle(
                          fontWeight: .w600,
                          fontSize: FontSizeToken.base,
                          color: context.colors.text,
                        ),
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        _timeAgo(notice.time),
                        style: TextStyle(
                          fontSize: FontSizeToken.sm,
                          color: context.colors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                if (notice.viewsCount > 0)
                  Row(
                    children: [
                      Icon(
                        LucideIcons.eye,
                        size: 13,
                        color: context.colors.textSubtle,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        '${notice.viewsCount}',
                        style: TextStyle(
                          fontSize: FontSizeToken.xs,
                          color: context.colors.textSubtle,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Text(
              notice.message,
              maxLines: 4,
              overflow: .ellipsis,
              style: TextStyle(
                fontSize: FontSizeToken.md,
                height: 1.4,
                color: context.colors.text,
              ),
            ),
            if (notice.imageUrl.isNotEmpty) ...[
              const SizedBox(height: Spacing.md),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: .horizontal,
                  itemCount: notice.imageUrl.length,
                  separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                  itemBuilder: (context, index) {
                    final rawUrl = notice.imageUrl[index];
                    return GestureDetector(
                      onTap: () => _openImage(context, notice, rawUrl),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                        child: Image.network(
                          ApiEndpoints.resolveImageUrl(rawUrl),
                          width: 200,
                          fit: .cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 200,
                            color: context.colors.border,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                _EngagementButton(
                  icon: LucideIcons.messageSquare,
                  label: '$_commentCount',
                  onTap: _showComments,
                ),
                const SizedBox(width: Spacing.lg),
                _EngagementButton(
                  icon: _isLiked ? Icons.favorite : LucideIcons.heart,
                  iconColor: _isLiked ? context.colors.danger : null,
                  label: '$_likeCount',
                  onTap: _toggleLike,
                ),
                const Spacer(),
                _EngagementButton(
                  icon: LucideIcons.share2,
                  onTap: () => _shareNotice(notice),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(String dateString) {
    if (dateString.isEmpty) return 'Just now';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (diff.inDays >= 2) {
        return '${diff.inDays} days ago';
      } else if (diff.inDays >= 1) {
        return 'Yesterday';
      } else if (diff.inHours >= 2) {
        return '${diff.inHours} hours ago';
      } else if (diff.inHours >= 1) {
        return '1 hour ago';
      } else if (diff.inMinutes >= 2) {
        return '${diff.inMinutes} minutes ago';
      } else if (diff.inMinutes >= 1) {
        return '1 minute ago';
      } else {
        return 'Just now';
      }
    } catch (_) {
      return dateString;
    }
  }
}

class _EngagementButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _EngagementButton({
    required this.icon,
    this.label = '',
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = context.colors.textSubtle;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusToken.xs),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.xs,
          horizontal: Spacing.xxs,
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: iconColor ?? defaultColor),
            if (label.isNotEmpty) ...[
              const SizedBox(width: Spacing.sm),
              Text(
                label,
                style: TextStyle(
                  color: iconColor ?? defaultColor,
                  fontSize: FontSizeToken.sm,
                  fontWeight: iconColor != null
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
