import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_tab_bar.dart';

class QuickFavoritesSection extends StatefulWidget {
  const QuickFavoritesSection({super.key});

  @override
  State<QuickFavoritesSection> createState() => _QuickFavoritesSectionState();
}

class _QuickFavoritesSectionState extends State<QuickFavoritesSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.xl),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.md,
                Spacing.md,
                Spacing.md,
                0,
              ),
              child: Text(
                'Quick Favorites',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: SectionTabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'University'),
                  Tab(text: 'Department'),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xl),
            SizedBox(
              height: 188,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _FavoritesGrid(items: _universityItems),
                  _FavoritesGrid(items: _departmentItems),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<_FavoriteItem> items;

  const _FavoritesGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.md),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return GestureDetector(
          onTap: item.route != null ? () => context.push(item.route!) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(RadiusToken.lg),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 24, color: item.color),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FavoriteItem {
  final String name;
  final IconData icon;
  final Color color;
  final String? route;

  const _FavoriteItem({
    required this.name,
    required this.icon,
    required this.color,
    this.route,
  });
}

// University tab items — updated to user's requested set
const List<_FavoriteItem> _universityItems = [
  _FavoriteItem(
    name: 'Faculties',
    icon: LucideIcons.building,
    color: Color(0xFF3B82F6),
    route: '/university/faculties',
  ),
  _FavoriteItem(
    name: 'Departments',
    icon: LucideIcons.building2,
    color: Color(0xFF8B5CF6),
    route: '/university/departments',
  ),
  _FavoriteItem(
    name: 'Halls',
    icon: LucideIcons.home,
    color: Color(0xFFEC4899),
    route: '/university/halls',
  ),
  _FavoriteItem(
    name: 'Alumni',
    icon: LucideIcons.graduationCap,
    color: Color(0xFFF59E0B),
    route: '/alumni',
  ),
  _FavoriteItem(
    name: 'Maps',
    icon: LucideIcons.map,
    color: Color(0xFF10B981),
    route: '/university/location',
  ),
  _FavoriteItem(
    name: 'About',
    icon: LucideIcons.info,
    color: Color(0xFF64748B),
    route: '/university',
  ),
];

// Department tab items — same as before
const List<_FavoriteItem> _departmentItems = [
  _FavoriteItem(
    name: 'Teachers',
    icon: LucideIcons.userCheck,
    color: Color(0xFF3B82F6),
    route: '/teacher',
  ),
  _FavoriteItem(
    name: 'Students',
    icon: LucideIcons.users,
    color: Color(0xFF8B5CF6),
    route: '/students',
  ),
  _FavoriteItem(
    name: 'CR',
    icon: LucideIcons.star,
    color: Color(0xFFF59E0B),
    route: '/cr',
  ),
  _FavoriteItem(
    name: 'Staffs',
    icon: LucideIcons.briefcase,
    color: Color(0xFF10B981),
    route: '/staff',
  ),
  _FavoriteItem(
    name: 'Notice',
    icon: LucideIcons.bell,
    color: Color(0xFFEF4444),
    route: '/department/notices',
  ),
  _FavoriteItem(
    name: 'About',
    icon: LucideIcons.info,
    color: Color(0xFF64748B),
    route: '/department',
  ),
];
