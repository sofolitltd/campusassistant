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
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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
        barrierColor: context.colors.textSubtle,
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
    final primaryColor = theme.appColors.primary;
    final borderColor = context.colors.border;
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
        clipBehavior: .none,
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
                    mainAxisSize: .min,
                    mainAxisAlignment: .center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 32,
                          height: 32,
                          fit: .contain,
                        ),
                      ),
                      if (!_collapsed) ...[
                        const SizedBox(width: Spacing.md),
                        Flexible(
                          child: Text(
                            'Campus Assistant',
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontWeight: .bold,
                              fontSize: FontSizeToken.lg,
                              color: context.colors.text,
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
                    padding: const EdgeInsets.all(Spacing.md),
                    children: List.generate(_items.length, (index) {
                      final item = _items[index];
                      final selected = widget.currentIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Spacing.xs),
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
                  padding: const EdgeInsets.all(Spacing.md),
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
                      const SizedBox(height: Spacing.xs),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(RadiusToken.md),
                          onTap: () => context.goNamed(AppRoute.profile.name),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: _collapsed ? 0 : 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: .min,
                              mainAxisAlignment: .center,
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
                                            fontWeight: .bold,
                                            fontSize: FontSizeToken.sm,
                                          ),
                                        )
                                      : null,
                                ),
                                if (!_collapsed) ...[
                                  const SizedBox(width: Spacing.md),
                                  Flexible(
                                    child: Text(
                                      userName.isNotEmpty
                                          ? userName
                                          : 'Profile',
                                      overflow: .ellipsis,
                                      style: TextStyle(
                                        fontSize: FontSizeToken.md,
                                        fontWeight: .w600,
                                        color: context.colors.text,
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
                    BoxShadow(color: context.colors.shadow, blurRadius: 4),
                  ],
                ),
                child: Icon(
                  _collapsed
                      ? LucideIcons.chevronRight
                      : LucideIcons.chevronLeft,
                  size: 14,
                  color: context.colors.textMuted,
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
        ? context.colors.onPrimary
        : (context.colors.textMuted);
    final textColor = selected
        ? context.colors.onPrimary
        : (context.colors.textMuted);

    return Tooltip(
      message: collapsed ? label : '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 0 : 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: selected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            child: Row(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: [
                Stack(
                  clipBehavior: .none,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.danger,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            badgeCount > 9 ? '9+' : '$badgeCount',
                            style: TextStyle(
                              color: context.colors.onPrimary,
                              fontSize: FontSizeToken.xxs,
                              fontWeight: .bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (!collapsed) ...[
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: FontSizeToken.base,
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
