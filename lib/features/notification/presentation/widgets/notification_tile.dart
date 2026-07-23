import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/enums/notification_type.dart';
import '/core/theme/tokens/app_radius.dart';

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
        return (LucideIcons.calendarClock, const Color(0xFF6C7BFF));
      case NotificationType.studyMaterial:
        return (LucideIcons.bookOpenText, const Color(0xFF22C55E));
      case NotificationType.communityPost:
        return (LucideIcons.messageSquare, const Color(0xFF3B82F6));
      case NotificationType.communityReply:
        return (LucideIcons.reply, const Color(0xFF8B5CF6));
      case NotificationType.subscription:
        return (LucideIcons.crown, const Color(0xFFF59E0B));
      case NotificationType.emergency:
        return (LucideIcons.alertTriangle, const Color(0xFFEF4444));
      case NotificationType.bloodRequest:
        return (LucideIcons.droplets, const Color(0xFFE11D48));
      case NotificationType.alumni:
        return (LucideIcons.graduationCap, const Color(0xFF14B8A6));
      case NotificationType.notice:
        return (LucideIcons.megaphone, const Color(0xFFF97316));
      case NotificationType.achievement:
        return (LucideIcons.trophy, const Color(0xFFFACC15));
      case NotificationType.club:
        return (LucideIcons.users, const Color(0xFFEC4899));
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
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
        child: Icon(LucideIcons.checkCheck, color: color, size: 24),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                notification.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          notification.imageUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: isDark ? 0.15 : 0.1),
                              borderRadius: BorderRadius.circular(10),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                color: isDark
                                    ? (notification.isRead
                                          ? Colors.white70
                                          : Colors.white)
                                    : (notification.isRead
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade900),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
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
