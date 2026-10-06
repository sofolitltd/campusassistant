import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/enums/notification_type.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback? onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    this.onDismiss,
  });

  (IconData, Color) _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.routineUpdate:
        return (LucideIcons.calendarClock, AccentToken.periwinkle);
      case NotificationType.studyMaterial:
        return (LucideIcons.bookOpenText, AccentToken.green);
      case NotificationType.communityPost:
        return (LucideIcons.messageSquare, AccentToken.blue);
      case NotificationType.communityReply:
        return (LucideIcons.reply, AccentToken.violet);
      case NotificationType.subscription:
        return (LucideIcons.crown, AccentToken.amber);
      case NotificationType.emergency:
        return (LucideIcons.alertTriangle, AccentToken.red);
      case NotificationType.bloodRequest:
        return (LucideIcons.droplets, AccentToken.rose);
      case NotificationType.alumni:
        return (LucideIcons.graduationCap, AccentToken.teal);
      case NotificationType.notice:
        return (LucideIcons.megaphone, AccentToken.orange);
      case NotificationType.achievement:
        return (LucideIcons.trophy, AccentToken.yellow);
      case NotificationType.club:
        return (LucideIcons.users, AccentToken.pink);
    }
  }

  String _timeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (icon, color) = _iconForType(notification.type);
    final timeAgo = _timeAgo(notification.timestamp);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.xxl),
        decoration: BoxDecoration(
          color: context.colors.danger.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
        child: Icon(LucideIcons.trash2, color: context.colors.danger, size: 22),
      ),
      onDismissed: (_) => onDismiss?.call(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.transparent
                : color.withValues(alpha: isDark ? 0.06 : 0.04),
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(
              color: notification.isRead
                  ? Colors.transparent
                  : color.withValues(alpha: isDark ? 0.15 : 0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.md,
            ),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                notification.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                        child: Image.network(
                          ApiEndpoints.resolveImageUrl(notification.imageUrl),
                          width: 40,
                          height: 40,
                          fit: .cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color.withValues(
                                alpha: isDark ? 0.15 : 0.1,
                              ),
                              borderRadius: BorderRadius.circular(
                                RadiusToken.md,
                              ),
                            ),
                            child: Icon(icon, color: color, size: 20),
                          ),
                        ),
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: isDark ? 0.15 : 0.1),
                          borderRadius: BorderRadius.circular(RadiusToken.md),
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        crossAxisAlignment: .start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: FontSizeToken.base,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                color: isDark
                                    ? (notification.isRead
                                          ? context.colors.textMuted
                                          : context.colors.onPrimary)
                                    : (notification.isRead
                                          ? context.colors.textMuted
                                          : context.colors.text),
                              ),
                              maxLines: 2,
                              overflow: .ellipsis,
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              fontSize: FontSizeToken.xs,
                              color: context.colors.textSubtle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: FontSizeToken.sm,
                          color: context.colors.textMuted,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: .ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: Spacing.sm,
                      top: Spacing.xxs,
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
