import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/app_notification.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_tile.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/widgets/custom_header_layout.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool _showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationsAsync = ref.watch(notificationsProvider);

    return CustomHeaderLayout(
      title: 'Notifications',
      showSearchBar: false,
      actions: [
        notificationsAsync.whenOrNull(
              data: (notifications) {
                final hasUnread = notifications.any((n) => !n.isRead);
                if (!hasUnread) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () {
                    ref.read(notificationRepositoryProvider).markAllAsRead();
                    ref.invalidate(notificationsProvider);
                  },
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ) ??
            const SizedBox.shrink(),
        const SizedBox(width: 4),
      ],
      body: notificationsAsync.when(
        data: (notifications) {
          final filtered = _showUnreadOnly
              ? notifications.where((n) => !n.isRead).toList()
              : notifications;

          if (filtered.isEmpty) {
            return _buildEmptyState(isDark);
          }

          final grouped = _groupByDate(filtered);

          return Column(
            children: [
              _buildFilterChip(isDark),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: grouped.entries.map((entry) {
                    return _buildDateSection(entry.key, entry.value, isDark);
                  }).toList(),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Error: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => setState(() => _showUnreadOnly = !_showUnreadOnly),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _showUnreadOnly
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.shade100),
              borderRadius: BorderRadius.circular(RadiusToken.sm),
              border: Border.all(
                color: _showUnreadOnly
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3)
                    : (isDark ? Colors.white10 : Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _showUnreadOnly ? LucideIcons.filter : LucideIcons.mailOpen,
                  size: 14,
                  color: _showUnreadOnly
                      ? Theme.of(context).colorScheme.primary
                      : (isDark ? Colors.white54 : Colors.grey.shade600),
                ),
                const SizedBox(width: 6),
                Text(
                  _showUnreadOnly ? 'Unread Only' : 'All Notifications',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _showUnreadOnly
                        ? Theme.of(context).colorScheme.primary
                        : (isDark ? Colors.white54 : Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _showUnreadOnly ? LucideIcons.inbox : LucideIcons.bellOff,
                size: 36,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _showUnreadOnly
                  ? 'No unread notifications'
                  : 'No notifications yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _showUnreadOnly
                  ? 'You\'ve caught up on everything!'
                  : 'You\'ll see updates here when they arrive.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<AppNotification>> _groupByDate(
    List<AppNotification> notifications,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

    final grouped = <String, List<AppNotification>>{};

    for (final n in notifications) {
      final date = DateTime(
        n.timestamp.year,
        n.timestamp.month,
        n.timestamp.day,
      );
      String section;
      if (date == today) {
        section = 'Today';
      } else if (date == yesterday) {
        section = 'Yesterday';
      } else if (date.isAfter(thisWeekStart)) {
        section = 'This Week';
      } else if (date.isAfter(lastWeekStart)) {
        section = 'Last Week';
      } else {
        section = 'Earlier';
      }
      grouped.putIfAbsent(section, () => []);
      grouped[section]!.add(n);
    }

    final orderedKeys = [
      'Today',
      'Yesterday',
      'This Week',
      'Last Week',
      'Earlier',
    ].where((k) => grouped.containsKey(k));
    return {for (final k in orderedKeys) k: grouped[k]!};
  }

  Widget _buildDateSection(
    String label,
    List<AppNotification> notifications,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...notifications.map(
          (notification) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: NotificationTile(
              notification: notification,
              onTap: () => _handleNotificationTap(notification),
              onDismiss: () => _handleDismiss(notification.id),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNotificationTap(AppNotification notification) async {
    await ref.read(notificationRepositoryProvider).markAsRead(notification.id);
    ref.invalidate(notificationsProvider);

    if (!mounted) return;

    context.push('/notifications/${notification.id}', extra: notification);
  }

  void _handleDismiss(String id) async {
    await ref.read(notificationRepositoryProvider).deleteNotification(id);
    ref.invalidate(notificationsProvider);
  }
}
