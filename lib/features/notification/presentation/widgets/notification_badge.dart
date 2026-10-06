import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme/app_colors.dart';
import '../providers/notification_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class NotificationBadge extends ConsumerWidget {
  final Widget icon;
  final VoidCallback onTap;

  const NotificationBadge({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadCountProvider);

    return Stack(
      clipBehavior: .none,
      children: [
        IconButton(
          tooltip: unreadCount > 0
              ? 'Notifications, $unreadCount unread'
              : 'Notifications',
          onPressed: onTap,
          icon: icon,
        ),
        if (unreadCount > 0)
          Positioned(
            top: 6,
            right: 6,
            child: TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: unreadCount),
              duration: const Duration(milliseconds: 300),
              builder: (context, count, child) {
                return Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                  decoration: BoxDecoration(
                    color: context.colors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: TextStyle(
                      color: context.colors.onDanger,
                      fontSize: FontSizeToken.xxs,
                      fontWeight: .bold,
                      height: 1,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
