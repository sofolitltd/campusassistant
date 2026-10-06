import 'dart:async';

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
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool _showUnreadOnly = false;
  bool _loadingMore = false;
  // Dismissible requires the widget to leave the tree the instant
  // onDismissed fires. _handleDismiss's delete call is a network round-trip,
  // so without this the underlying list (from notificationsProvider) hasn't
  // changed yet by the next frame and Flutter throws "A dismissed
  // Dismissible widget is still part of the tree". Hiding the id locally,
  // synchronously, is what actually satisfies that contract.
  final Set<String> _dismissedIds = {};

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
                  child: Text(
                    'Mark all read',
                    style: TextStyle(
                      fontSize: FontSizeToken.sm,
                      fontWeight: .w600,
                      color: context.colors.onPrimary,
                    ),
                  ),
                );
              },
            ) ??
            const SizedBox.shrink(),
        const SizedBox(width: Spacing.xs),
      ],
      body: notificationsAsync.when(
        data: (notifications) {
          final visible = notifications.where(
            (n) => !_dismissedIds.contains(n.id),
          );
          final filtered = _showUnreadOnly
              ? visible.where((n) => !n.isRead).toList()
              : visible.toList();

          if (filtered.isEmpty) {
            return _buildEmptyState(isDark);
          }

          final grouped = _groupByDate(filtered);

          final notifier = ref.read(notificationsProvider.notifier);

          return Column(
            children: [
              _buildFilterChip(isDark),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.sm,
                    Spacing.lg,
                    Spacing.xxl,
                  ),
                  children: [
                    ...grouped.entries.map((entry) {
                      return _buildDateSection(entry.key, entry.value, isDark);
                    }),
                    if (notifier.hasMore) _buildLoadMore(isDark, notifier),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xxxl),
            child: Text(
              'Error: $err',
              style: TextStyle(color: context.colors.danger),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.xs,
        Spacing.lg,
        Spacing.sm,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => setState(() => _showUnreadOnly = !_showUnreadOnly),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: _showUnreadOnly
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : (context.colors.surfaceAlt),
              borderRadius: BorderRadius.circular(RadiusToken.sm),
              border: Border.all(
                color: _showUnreadOnly
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3)
                    : (context.colors.border),
              ),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  _showUnreadOnly ? LucideIcons.filter : LucideIcons.mailOpen,
                  size: 14,
                  color: _showUnreadOnly
                      ? Theme.of(context).colorScheme.primary
                      : (context.colors.textMuted),
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  _showUnreadOnly ? 'Unread Only' : 'All Notifications',
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    fontWeight: .w600,
                    color: _showUnreadOnly
                        ? Theme.of(context).colorScheme.primary
                        : (context.colors.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMore(bool isDark, NotificationsNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
      child: Center(
        child: _loadingMore
            ? const CupertinoActivityIndicator()
            : TextButton(
                onPressed: () async {
                  setState(() => _loadingMore = true);
                  await notifier.loadMore();
                  if (mounted) setState(() => _loadingMore = false);
                },
                child: Text(
                  'Load older notifications',
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    fontWeight: .w600,
                    color: context.colors.textMuted,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxxl),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.colors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _showUnreadOnly ? LucideIcons.inbox : LucideIcons.bellOff,
                size: 36,
                color: context.colors.textSubtle,
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Text(
              _showUnreadOnly
                  ? 'No unread notifications'
                  : 'No notifications yet',
              style: TextStyle(
                fontSize: FontSizeToken.lg,
                fontWeight: .w600,
                color: context.colors.textMuted,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              _showUnreadOnly
                  ? 'You\'ve caught up on everything!'
                  : 'You\'ll see updates here when they arrive.',
              style: TextStyle(
                fontSize: FontSizeToken.md,
                color: context.colors.textSubtle,
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
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: Spacing.md,
            bottom: Spacing.md,
            left: Spacing.xs,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: FontSizeToken.sm,
              fontWeight: .bold,
              color: context.colors.textSubtle,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...notifications.map(
          (notification) => Padding(
            padding: const EdgeInsets.only(bottom: Spacing.md),
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

  void _handleNotificationTap(AppNotification notification) {
    // Optimistic: flip isRead locally and navigate immediately, instead of
    // awaiting the network call + invalidating (refetching) the whole list
    // just to reflect one row's read state — that used to cause a visible
    // flicker/delay on every single tap.
    ref
        .read(notificationsProvider.notifier)
        .updateLocal(notification.id, (n) => n.copyWith(isRead: true));
    unawaited(
      ref.read(notificationRepositoryProvider).markAsRead(notification.id),
    );

    context.push(
      '/notifications/${notification.id}',
      extra: notification.copyWith(isRead: true),
    );
  }

  void _handleDismiss(String id) async {
    setState(() => _dismissedIds.add(id));
    try {
      await ref.read(notificationRepositoryProvider).deleteNotification(id);
      ref.invalidate(notificationsProvider);
    } catch (e) {
      if (!mounted) return;
      // Deletion failed — bring the tile back and let the user know, rather
      // than leaving it permanently (and incorrectly) hidden.
      setState(() => _dismissedIds.remove(id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete notification: $e')),
      );
    }
  }
}
