import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/enums/notification_type.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';
import '/core/theme/tokens/app_control.dart';

class NotificationDetailScreen extends ConsumerWidget {
  final dynamic notification;

  const NotificationDetailScreen({super.key, this.notification});

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
                foregroundColor: context.colors.onPrimary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (notif.imageUrl != null)
                        Image.network(
                          ApiEndpoints.resolveImageUrl(notif.imageUrl),
                          fit: .cover,
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
                              context.colors.surfaceInverse.withValues(
                                alpha: 0.6,
                              ),
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
                                color: context.colors.surface.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(
                                  RadiusToken.lg,
                                ),
                              ),
                              child: Icon(
                                icon,
                                color: context.colors.onPrimary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: Spacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.sm,
                                      vertical: Spacing.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.colors.surface.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        RadiusToken.sm,
                                      ),
                                    ),
                                    child: Text(
                                      notif.type.label,
                                      style: TextStyle(
                                        fontSize: FontSizeToken.xs,
                                        fontWeight: .bold,
                                        color: context.colors.onPrimary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: Spacing.sm),
                                  Text(
                                    notif.title,
                                    style: TextStyle(
                                      fontSize: FontSizeToken.xxl,
                                      fontWeight: .bold,
                                      color: context.colors.onPrimary,
                                      height: 1.2,
                                    ),
                                    maxLines: 3,
                                    overflow: .ellipsis,
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
                  const SizedBox(width: Spacing.xs),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.xl,
                    Spacing.xxl,
                    Spacing.xl,
                    Spacing.xxxl,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.clock,
                            size: 14,
                            color: context.colors.textSubtle,
                          ),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: FontSizeToken.md,
                              color: context.colors.textSubtle,
                            ),
                          ),
                          const Spacer(),
                          if (notif.isRead)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                                vertical: Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.surfaceAlt,
                                borderRadius: BorderRadius.circular(
                                  RadiusToken.sm,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: .min,
                                children: [
                                  Icon(
                                    LucideIcons.checkCheck,
                                    size: 12,
                                    color: context.colors.textSubtle,
                                  ),
                                  const SizedBox(width: Spacing.xs),
                                  Text(
                                    'Read',
                                    style: TextStyle(
                                      fontSize: FontSizeToken.xs,
                                      color: context.colors.textSubtle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xl),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Spacing.lg),
                        decoration: BoxDecoration(
                          color: context.colors.surfaceAlt,
                          borderRadius: BorderRadius.circular(RadiusToken.md),
                          border: Border.all(color: context.colors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              notif.title,
                              style: TextStyle(
                                fontSize: FontSizeToken.xl,
                                fontWeight: .bold,
                                color: context.colors.text,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            Text(
                              notif.body,
                              style: TextStyle(
                                fontSize: FontSizeToken.lg,
                                color: context.colors.textMuted,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (notif.actionRoute != null) ...[
                        const SizedBox(height: Spacing.xxl),
                        SizedBox(
                          width: double.infinity,
                          height: ControlToken.height,
                          child: ElevatedButton.icon(
                            onPressed: () => _navigateToSource(context, notif),
                            icon: const Icon(
                              LucideIcons.arrowUpRight,
                              size: 18,
                            ),
                            label: Text(
                              'Go to ${_sourceLabel(notif.type)}',
                              style: const TextStyle(fontWeight: .bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: Spacing.lg),
                      SizedBox(
                        width: double.infinity,
                        height: ControlToken.height,
                        child: OutlinedButton.icon(
                          onPressed: () => _shareNotification(notif),
                          icon: const Icon(LucideIcons.share2, size: 18),
                          label: const Text(
                            'Share Notification',
                            style: TextStyle(fontWeight: .w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: context.colors.borderStrong,
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
