import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_card.dart';
import '/core/widgets/section_tab_bar.dart';
import '../widgets/home_section.dart';
import '/core/theme/tokens/app_font_size.dart';

class QuickFavoritesSection extends StatefulWidget {
  const QuickFavoritesSection({super.key});

  @override
  State<QuickFavoritesSection> createState() => _QuickFavoritesSectionState();
}

class _QuickFavoritesSectionState extends State<QuickFavoritesSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Both tabs have exactly 6 items — used to size the grid's height exactly
  // for whatever crossAxisCount the current width resolves to.
  static const _gridItemCount = 6;
  static const _gridSpacing = Spacing.md - 2; // 10
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
    if (width >= 640) return 6;
    if (width >= 480) return 4;
    return 3;
  }

  /// TabBarView needs a bounded height ancestor, so compute the exact pixel
  /// height for the current width and column count.
  double _gridHeightFor(double contentWidth, int crossAxisCount) {
    final gridWidth = contentWidth - Spacing.md * 2;
    final cellWidth =
        (gridWidth - _gridSpacing * (crossAxisCount - 1)) / crossAxisCount;
    final cellHeight = cellWidth / _childAspectRatio;
    final rows = (_gridItemCount / crossAxisCount).ceil();
    return rows * cellHeight + (rows - 1) * _gridSpacing + Spacing.md;
  }

  @override
  Widget build(BuildContext context) {
    // Pulled up so the gap above is Spacing.md (12px); the bottom gap shrinks by the same amount so the
    // sections below don't move.
    return Transform.translate(
      offset: const Offset(0, -(Spacing.lg - Spacing.md)),
      child: HomeSection(
        bottom: Spacing.md,
        child: SectionCard(
          margin: const EdgeInsets.symmetric(horizontal: homeInset),
          radius: homeCardRadius,
          padding: EdgeInsets.zero,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = _crossAxisCountFor(constraints.maxWidth);
              final gridHeight = _gridHeightFor(
                constraints.maxWidth,
                crossAxisCount,
              );

              return Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  const HomeSectionHeader(
                    'Quick Favorites',
                    padding: EdgeInsets.fromLTRB(
                      Spacing.md,
                      Spacing.md,
                      Spacing.md,
                      0,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
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
                  const SizedBox(height: Spacing.lg),
                  SizedBox(
                    height: gridHeight,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _FavoritesGrid(
                          items: _universityItems,
                          crossAxisCount: crossAxisCount,
                          spacing: _gridSpacing,
                          aspectRatio: _childAspectRatio,
                        ),
                        _FavoritesGrid(
                          items: _departmentItems,
                          crossAxisCount: crossAxisCount,
                          spacing: _gridSpacing,
                          aspectRatio: _childAspectRatio,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid({
    required this.items,
    required this.crossAxisCount,
    required this.spacing,
    required this.aspectRatio,
  });

  final List<_FavoriteItem> items;
  final int crossAxisCount;
  final double spacing;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.md),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final shape = BorderRadius.circular(RadiusToken.md);

        return Material(
          color: colors.surfaceAlt,
          shape: RoundedRectangleBorder(
            borderRadius: shape,
            side: BorderSide(color: colors.border),
          ),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: () => context.push(item.route),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Icon(item.icon, size: 24, color: colors.primary),
                const SizedBox(height: Spacing.sm),
                Text(
                  item.name,
                  textAlign: .center,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    fontWeight: .w500,
                    color: colors.text,
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
  const _FavoriteItem(this.name, this.icon, this.route);

  final String name;
  final IconData icon;
  final String route;
}

const List<_FavoriteItem> _universityItems = [
  _FavoriteItem('Faculties', LucideIcons.building, '/university/faculties'),
  _FavoriteItem(
    'Departments',
    LucideIcons.building2,
    '/university/departments',
  ),
  _FavoriteItem('Halls', LucideIcons.house, '/university/halls'),
  _FavoriteItem('Alumni', LucideIcons.graduationCap, '/alumni'),
  _FavoriteItem('Maps', LucideIcons.map, '/university/location'),
  _FavoriteItem('About', LucideIcons.info, '/university'),
];

const List<_FavoriteItem> _departmentItems = [
  _FavoriteItem('Teachers', LucideIcons.userCheck, '/teacher'),
  _FavoriteItem('Students', LucideIcons.users, '/students'),
  _FavoriteItem('CR', LucideIcons.star, '/cr'),
  _FavoriteItem('Staffs', LucideIcons.briefcase, '/staff'),
  _FavoriteItem('Notice', LucideIcons.bell, '/department/notices'),
  _FavoriteItem('About', LucideIcons.info, '/department'),
];
