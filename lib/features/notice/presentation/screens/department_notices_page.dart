import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '../../data/models/notice_model.dart';
import '../providers/notice_provider.dart';
import '../widgets/notice_comments_sheet.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/widgets/custom_header_layout.dart';
import '/routes/app_route.dart';

class DepartmentNoticesPage extends ConsumerWidget {
  const DepartmentNoticesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(departmentNoticesProvider);

    return CustomHeaderLayout(
      title: 'Notices',
      showSearchBar: false,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(departmentNoticesProvider);
          await ref.read(departmentNoticesProvider.future);
        },
        child: noticesAsync.when(
          data: (notices) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            if (notices.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.megaphone,
                            size: 64,
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notices yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(16),
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return _NoticeCard(notice: notice);
              },
            );
          },
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: const Center(child: CupertinoActivityIndicator()),
              ),
            ],
          ),
          error: (err, _) => _FallbackNoticeList(),
        ),
      ),
    );
  }
}

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

void _showNoticeDetails(BuildContext context, WidgetRef ref, NoticeModel notice) {
  if (notice.id.isNotEmpty) {
    ref.read(noticeRepositoryProvider).viewNotice(notice.id).catchError((_) {});
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? Theme.of(context).cardColor : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).appColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                      ),
                      child: Icon(
                        LucideIcons.megaphone,
                        size: 22,
                        color: Theme.of(context).appColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notice.uploader,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatExact(notice.time),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  notice.message,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.grey.shade800,
                  ),
                ),
                if (notice.imageUrl.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  ...notice.imageUrl.map(
                    (url) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _openImage(context, notice, url),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(RadiusToken.sm),
                          child: Image.network(
                            ApiEndpoints.resolveImageUrl(url),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 160,
                              color: Colors.grey.shade200,
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

class _NoticeCard extends ConsumerStatefulWidget {
  final NoticeModel notice;

  const _NoticeCard({required this.notice});

  @override
  ConsumerState<_NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends ConsumerState<_NoticeCard> {
  late bool _isLiked;
  late int _likeCount;
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _syncFromNotice();
  }

  @override
  void didUpdateWidget(_NoticeCard oldWidget) {
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
        await ref
            .read(noticeRepositoryProvider)
            .unlikeNotice(widget.notice.id);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showNoticeDetails(context, ref, notice),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
            width: 1,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).appColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(RadiusToken.sm),
                  ),
                  child: Icon(
                    LucideIcons.megaphone,
                    size: 20,
                    color: Theme.of(context).appColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.uploader,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _timeAgo(notice.time),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
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
                        color: isDark ? Colors.white30 : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${notice.viewsCount}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? Colors.white30
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              notice.message,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? Colors.white70 : Colors.grey.shade800,
              ),
            ),
            if (notice.imageUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: notice.imageUrl.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final rawUrl = notice.imageUrl[index];
                    return GestureDetector(
                      onTap: () => _openImage(context, notice, rawUrl),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                        child: Image.network(
                          ApiEndpoints.resolveImageUrl(rawUrl),
                          width: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 200,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                _EngagementButton(
                  icon: LucideIcons.messageSquare,
                  label: '$_commentCount',
                  onTap: _showComments,
                ),
                const SizedBox(width: 16),
                _EngagementButton(
                  icon: _isLiked ? Icons.favorite : LucideIcons.heart,
                  iconColor: _isLiked ? Colors.red : null,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white38 : Colors.grey.shade500;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          children: [
            Icon(icon, size: 17, color: iconColor ?? defaultColor),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: iconColor ?? defaultColor,
                  fontSize: 12,
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

class _FallbackNoticeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fallbackNotices = [
      NoticeModel(
        id: '',
        uploader: 'Department Office',
        message:
            'Midterm exam schedule has been published. Check the notice board for details.',
        imageUrl: [],
        time: DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
      ),
      NoticeModel(
        id: '',
        uploader: 'Academic Committee',
        message:
            'Classes will remain suspended on Wednesday due to a university-wide holiday.',
        imageUrl: [],
        time: DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      ),
      NoticeModel(
        id: '',
        uploader: 'Faculty Advisor',
        message:
            'Project submission deadline extended to next Friday. All group leaders must submit the hard copy to the department office.',
        imageUrl: [],
        time: DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
      ),
    ];

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.all(16),
      itemCount: fallbackNotices.length,
      itemBuilder: (context, index) {
        return _NoticeCard(notice: fallbackNotices[index]);
      },
    );
  }
}
