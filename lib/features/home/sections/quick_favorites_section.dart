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

  // Both tabs have exactly 6 items — used to size the grid's height exactly
  // for whatever crossAxisCount the current width resolves to.
  static const _gridItemCount = 6;
  static const _crossAxisSpacing = 10.0;
  static const _mainAxisSpacing = 10.0;
  static const _childAspectRatio = 1.3;

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

  /// 3 columns on phone widths; more on tablet/desktop/web so cells don't
  /// stretch into oversized rectangles on wide viewports.
  int _crossAxisCountFor(double width) {
    if (width >= 700) return 6;
    if (width >= 480) return 4;
    return 3;
  }

  /// TabBarView needs a bounded height ancestor, so the grid can't just
  /// size itself — compute the exact pixel height for the current width and
  /// column count instead of a hardcoded constant tuned for one layout.
  double _gridHeightFor(double contentWidth, int crossAxisCount) {
    final gridWidth = contentWidth - Spacing.md * 2;
    final cellWidth =
        (gridWidth - _crossAxisSpacing * (crossAxisCount - 1)) / crossAxisCount;
    final cellHeight = cellWidth / _childAspectRatio;
    final rows = (_gridItemCount / crossAxisCount).ceil();
    return rows * cellHeight + (rows - 1) * _mainAxisSpacing + Spacing.md;
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = _crossAxisCountFor(constraints.maxWidth);
            final gridHeight = _gridHeightFor(
              constraints.maxWidth,
              crossAxisCount,
            );

            return Column(
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
                  height: gridHeight,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _FavoritesGrid(
                        items: _universityItems,
                        crossAxisCount: crossAxisCount,
                      ),
                      _FavoritesGrid(
                        items: _departmentItems,
                        crossAxisCount: crossAxisCount,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<_FavoriteItem> items;
  final int crossAxisCount;

  const _FavoritesGrid({required this.items, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.md),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
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
