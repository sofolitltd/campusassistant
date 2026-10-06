import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/custom_drawer.dart';
import '../core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Scaffold(
          key: scaffoldKey,
          drawer: const CustomDrawer(),
          body: navigationShell,
          bottomNavigationBar: _BlurryBottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class _BlurryBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const _BlurryBottomNavBar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  static const _items = [
    _NavItem(
      icon: LucideIcons.house,
      selectedIcon: LucideIcons.house,
      label: 'Home',
    ),
    _NavItem(
      icon: LucideIcons.bookOpen,
      selectedIcon: LucideIcons.bookOpen,
      label: 'Study',
    ),
    _NavItem(
      icon: LucideIcons.briefcase,
      selectedIcon: LucideIcons.briefcase,
      label: 'Career',
    ),
    _NavItem(
      icon: LucideIcons.users,
      selectedIcon: LucideIcons.users,
      label: 'Community',
    ),
    _NavItem(
      icon: LucideIcons.userRound,
      selectedIcon: LucideIcons.userRound,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(RadiusToken.xxl),
          topRight: Radius.circular(RadiusToken.xxl),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(RadiusToken.xxl),
          topRight: Radius.circular(RadiusToken.xxl),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surface.withValues(alpha: 0.82),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(RadiusToken.xxl),
                topRight: Radius.circular(RadiusToken.xxl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 60,
                child: Row(
                  children: List.generate(_items.length, (index) {
                    final item = _items[index];
                    final isSelected = currentIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onDestinationSelected(index),
                        child: Column(
                          mainAxisAlignment: .start,
                          children: [
                            // Top indicator bar
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              height: 3,
                              width: isSelected ? 32 : 0,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(RadiusToken.xs),
                                  bottomRight: Radius.circular(RadiusToken.xs),
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.sm),
                            Icon(
                              isSelected ? item.selectedIcon : item.icon,
                              size: 22,
                              color: isSelected
                                  ? primaryColor
                                  : context.colors.textSubtle,
                            ),
                            const SizedBox(height: Spacing.xxs),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: FontSizeToken.xs,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? primaryColor
                                    : context.colors.textSubtle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
