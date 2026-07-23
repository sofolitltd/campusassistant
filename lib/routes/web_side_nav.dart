import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/notification/presentation/providers/notification_provider.dart';
import '/widgets/custom_drawer.dart';
import 'app_route.dart';

/// Collapsible left sidebar shown instead of a NavigationRail on large/web
/// screens — styled to match the admin dashboard's sidebar (components/sidebar.tsx):
/// logo header, active-item pill highlight, collapse toggle floating on the
/// edge, secondary actions pinned to the bottom.
class WebSideNav extends ConsumerStatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const WebSideNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  static const expandedWidth = 260.0;
  static const collapsedWidth = 80.0;

  @override
  ConsumerState<WebSideNav> createState() => _WebSideNavState();
}

class _WebSideNavState extends ConsumerState<WebSideNav> {
  bool _collapsed = false;

  static const _items = [
    _NavItem(icon: LucideIcons.house, label: 'Home'),
    _NavItem(icon: LucideIcons.bookOpen, label: 'Study'),
    _NavItem(icon: LucideIcons.briefcase, label: 'Career'),
    _NavItem(icon: LucideIcons.users, label: 'Community'),
    _NavItem(icon: LucideIcons.userRound, label: 'Profile'),
  ];

  void _openMenu(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black38,
        pageBuilder: (_, _, _) => const CustomDrawer(),
        transitionsBuilder: (_, anim, _, child) {
          final offset = Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(anim);
          return SlideTransition(
            position: offset,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(width: 300, child: child),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.appColors.primaryColor;
    final borderColor = isDark ? Colors.white10 : Colors.grey.shade200;
    final userAsync = ref.watch(userProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    final userName = userAsync.value?.name ?? '';
    final userImage = userAsync.value?.image ?? '';
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';

    final width = _collapsed
        ? WebSideNav.collapsedWidth
        : WebSideNav.expandedWidth;

    return SizedBox(
      width: width + 12, // room for the floating toggle to overflow
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            width: width,
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(right: BorderSide(color: borderColor)),
            ),
            child: Column(
              children: [
                // Logo header
                Container(
                  height: 64,
                  padding: EdgeInsets.symmetric(
                    horizontal: _collapsed ? 0 : 20,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: borderColor)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (!_collapsed) ...[
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Campus Assistant',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Nav items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: List.generate(_items.length, (index) {
                      final item = _items[index];
                      final selected = widget.currentIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _SideNavTile(
                          icon: item.icon,
                          label: item.label,
                          selected: selected,
                          collapsed: _collapsed,
                          activeColor: primaryColor,
                          isDark: isDark,
                          onTap: () => widget.onDestinationSelected(index),
                        ),
                      );
                    }),
                  ),
                ),

                // Bottom: notifications, more, profile
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  child: Column(
                    children: [
                      _SideNavTile(
                        icon: LucideIcons.bell,
                        label: 'Notifications',
                        selected: false,
                        collapsed: _collapsed,
                        activeColor: primaryColor,
                        isDark: isDark,
                        badgeCount: unreadCount,
                        onTap: () => context.push(AppRoute.notifications.path),
                      ),
                      _SideNavTile(
                        icon: LucideIcons.menu,
                        label: 'More',
                        selected: false,
                        collapsed: _collapsed,
                        activeColor: primaryColor,
                        isDark: isDark,
                        onTap: () => _openMenu(context),
                      ),
                      const SizedBox(height: 4),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => context.goNamed(AppRoute.profile.name),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: _collapsed ? 0 : 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: primaryColor.withValues(
                                    alpha: 0.15,
                                  ),
                                  backgroundImage: userImage.isNotEmpty
                                      ? NetworkImage(
                                          ApiEndpoints.resolveImageUrl(
                                            userImage,
                                          ),
                                        )
                                      : null,
                                  child: userImage.isEmpty
                                      ? Text(
                                          initial,
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        )
                                      : null,
                                ),
                                if (!_collapsed) ...[
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      userName.isNotEmpty
                                          ? userName
                                          : 'Profile',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Collapse toggle
          Positioned(
            right: 0,
            top: 52,
            child: GestureDetector(
              onTap: () => setState(() => _collapsed = !_collapsed),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.cardColor,
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  _collapsed
                      ? LucideIcons.chevronRight
                      : LucideIcons.chevronLeft,
                  size: 14,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool collapsed;
  final Color activeColor;
  final bool isDark;
  final int badgeCount;
  final VoidCallback onTap;

  const _SideNavTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.collapsed,
    required this.activeColor,
    required this.isDark,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = selected
        ? Colors.white
        : (isDark ? Colors.white70 : Colors.grey.shade600);
    final textColor = selected
        ? Colors.white
        : (isDark ? Colors.white70 : Colors.grey.shade700);

    return Tooltip(
      message: collapsed ? label : '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 0 : 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: selected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(icon, size: 20, color: iconColor),
                    if (badgeCount > 0)
                      Positioned(
                        top: -4,
                        right: -6,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            badgeCount > 9 ? '9+' : '$badgeCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
