import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/custom_drawer.dart';
import '../core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_layout.dart';

/// Branch indices match the StatefulShellRoute.indexedStack branch order in
/// router_config.dart: 0=Home, 1=Study, 2=Career, 3=Community, 4=Profile.
/// Which of those branches show up as a tab depends on the logged-in role —
/// Teacher/Staff accounts don't have student coursework/career/community
/// use cases, so their nav bar is intentionally shorter. The branches
/// themselves still exist either way; only the tab is hidden.
const _studentTabs = [0, 1, 2, 3, 4];
const _teacherTabs = [0, 1, 4]; // Home, Study, Profile
const _staffTabs = [0, 4]; // Home, Profile

List<int> _tabsForRole(String? role) {
  switch (role) {
    case 'teacher':
      return _teacherTabs;
    case 'staff':
      return _staffTabs;
    default:
      return _studentTabs;
  }
}

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentUserProvider).value?.role;
    final visibleBranches = _tabsForRole(role);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: AppLayout.pageWidth),
        child: Scaffold(
          key: scaffoldKey,
          drawer: const CustomDrawer(),
          body: navigationShell,
          bottomNavigationBar: _BlurryBottomNavBar(
            currentIndex: navigationShell.currentIndex,
            visibleBranches: visibleBranches,
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
  final List<int> visibleBranches;
  final ValueChanged<int> onDestinationSelected;

  const _BlurryBottomNavBar({
    required this.currentIndex,
    required this.visibleBranches,
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
                  children: visibleBranches.map((branchIndex) {
                    final item = _items[branchIndex];
                    final isSelected = currentIndex == branchIndex;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onDestinationSelected(branchIndex),
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
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
