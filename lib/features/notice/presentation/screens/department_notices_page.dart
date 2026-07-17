import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/models/notice_model.dart';
import '../providers/notice_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/widgets/red_header_layout.dart';

class DepartmentNoticesPage extends ConsumerWidget {
  const DepartmentNoticesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(departmentNoticesProvider);

    return RedHeaderLayout(
      title: 'Notices',
      showSearchBar: false,
      body: noticesAsync.when(
        data: (notices) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          if (notices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.megaphone,
                    size: 64,
                    color: isDark ? Colors.white10 : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notices yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final notice = notices[index];
              return _NoticeCard(notice: notice);
            },
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => _FallbackNoticeList(),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final NoticeModel notice;

  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
                  color: Theme.of(context).appColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                child: Icon(
                  LucideIcons.megaphone,
                  size: 20,
                  color: Theme.of(context).appColors.primaryColor,
                ),
              ),
              SizedBox(width: 12),
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
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notice.message,
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
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(RadiusToken.sm),
                    child: Image.network(
                      notice.imageUrl[index],
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 200,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
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

class _FallbackNoticeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fallbackNotices = [
      NoticeModel(
        uploader: 'Department Office',
        message:
            'Midterm exam schedule has been published. Check the notice board for details.',
        imageUrl: [],
        batch: [],
        seen: [],
        time: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      ),
      NoticeModel(
        uploader: 'Academic Committee',
        message:
            'Classes will remain suspended on Wednesday due to a university-wide holiday.',
        imageUrl: [],
        batch: [],
        seen: [],
        time: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      ),
      NoticeModel(
        uploader: 'Faculty Advisor',
        message:
            'Project submission deadline extended to next Friday. All group leaders must submit the hard copy to the department office.',
        imageUrl: [],
        batch: [],
        seen: [],
        time: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      ),
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: fallbackNotices.length,
      itemBuilder: (context, index) {
        return _NoticeCard(notice: fallbackNotices[index]);
      },
    );
  }
}
