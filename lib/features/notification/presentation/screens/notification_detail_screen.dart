import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/enums/notification_type.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class NotificationDetailScreen extends ConsumerWidget {
  final dynamic notification;

  const NotificationDetailScreen({super.key, this.notification});

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

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');

    if (diff.inDays == 0) {
      return 'Today at $hour:$minute $amPm';
    } else if (diff.inDays == 1) {
      return 'Yesterday at $hour:$minute $amPm';
    } else {
      return '${dt.day} ${months[dt.month - 1]} ${dt.year} at $hour:$minute $amPm';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppNotification? notif = notification is AppNotification
        ? notification as AppNotification
        : null;

    if (notif == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notification')),
        body: const Center(child: Text('Notification not found')),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (icon, color) = _iconForType(notif.type);
    final formattedDate = _formatDateTime(notif.timestamp);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: color,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (notif.imageUrl != null)
                        Image.network(
                          notif.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _gradientBg(color),
                        )
                      else
                        _gradientBg(color),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 24,
                        right: 24,
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(icon, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      notif.type.label,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    notif.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(LucideIcons.share2),
                    onPressed: () => _shareNotification(notif),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.clock,
                            size: 14,
                            color: isDark
                                ? Colors.grey.shade500
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade500,
                            ),
                          ),
                          const Spacer(),
                          if (notif.isRead)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    LucideIcons.checkCheck,
                                    size: 12,
                                    color: isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Read',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.03)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(RadiusToken.md),
                          border: Border.all(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Colors.grey.shade900,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            Text(
                              notif.body,
                              style: TextStyle(
                                fontSize: 15,
                                color: isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (notif.actionRoute != null) ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () => _navigateToSource(context, notif),
                            icon: const Icon(
                              LucideIcons.arrowUpRight,
                              size: 18,
                            ),
                            label: Text(
                              'Go to ${_sourceLabel(notif.type)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  RadiusToken.md,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: Spacing.lg),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () => _shareNotification(notif),
                          icon: const Icon(LucideIcons.share2, size: 18),
                          label: const Text(
                            'Share Notification',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                RadiusToken.md,
                              ),
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradientBg(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  String _sourceLabel(NotificationType type) {
    switch (type) {
      case NotificationType.routineUpdate:
        return 'Routine';
      case NotificationType.studyMaterial:
        return 'Study Material';
      case NotificationType.communityPost:
      case NotificationType.communityReply:
        return 'Community';
      case NotificationType.subscription:
        return 'Subscription';
      case NotificationType.emergency:
        return 'Emergency';
      case NotificationType.bloodRequest:
        return 'Blood Bank';
      case NotificationType.alumni:
        return 'Alumni';
      case NotificationType.notice:
        return 'Notices';
      case NotificationType.achievement:
        return 'Profile';
      case NotificationType.club:
        return 'Club';
    }
  }

  void _navigateToSource(BuildContext context, AppNotification notif) {
    final route = notif.actionRoute;
    if (route != null) {
      context.push(route, extra: notif.actionParams);
    }
  }

  void _shareNotification(AppNotification notif) {
    final buffer = StringBuffer();
    buffer.writeln('📢 ${notif.title}');
    buffer.writeln();
    buffer.writeln(notif.body);
    buffer.writeln();
    buffer.writeln('Type: ${notif.type.label}');
    buffer.writeln('Shared via Campus Assistant');

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString().trim(),
        subject: 'Notification: ${notif.title}',
      ),
    );
  }
}
