import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/notification/presentation/widgets/notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/ads/banner_ad_widget.dart';
import '/core/widgets/mouse_wheel_horizontal_scroll.dart';
import '/routes/app_route.dart';
import '../../features/auth/presentation/providers/user_profile_provider.dart';
import 'sections/banner_section.dart';
import 'sections/subscription_section.dart';
import 'sections/quick_favorites_section.dart';
import 'sections/skill_up_section.dart';
import 'sections/marketplace_section.dart';
import 'widgets/home_drawer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _shortcutsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _shortcutsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider);
    final userName = userAsync.value?.name ?? 'Loading...';
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'M';
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const HomeDrawer(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Header Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal.shade600,
                    Colors.teal.shade300,
                    Colors.teal.shade100,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.55, 1.0],
                  tileMode: TileMode.decal,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => context.goNamed(AppRoute.profile.name),
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withValues(
                                alpha: .2,
                              ),
                              radius: 20,
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  LucideIcons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 4),
                              NotificationBadge(
                                icon: const Icon(
                                  LucideIcons.bell,
                                  color: Colors.white,
                                ),
                                onTap: () =>
                                    context.push(AppRoute.notifications.path),
                              ),
                              GestureDetector(
                                onTap: () => Scaffold.of(context).openDrawer(),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Greeting
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _timeBasedGreeting(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // White Section below
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: Spacing.sm),

                    // Shortcut Cards
                    SizedBox(
                      height: 200,
                      child: MouseWheelHorizontalScroll(
                        controller: _shortcutsScrollController,
                        child: MasonryGridView(
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                          controller: _shortcutsScrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          children: [
                            _buildShortcutCard(
                              theme: theme,
                              title: 'Class\nRoutine',
                              icon: LucideIcons.calendarDays,
                              route: '/routine',
                              color: const Color(0xFF3B82F6),
                            ),
                            _buildShortcutCard(
                              theme: theme,
                              title: 'Alumni\nNetwork',
                              icon: LucideIcons.graduationCap,
                              route: '/alumni',
                              color: const Color(0xFF8B5CF6),
                            ),
                            _buildShortcutCard(
                              theme: theme,
                              title: 'Emergency\nContacts',
                              icon: LucideIcons.phoneCall,
                              route: '/emergency',
                              color: const Color(0xFFEF4444),
                            ),
                            _buildShortcutCard(
                              theme: theme,
                              title: 'Transport\nServices',
                              icon: LucideIcons.bus,
                              route: '/transport',
                              color: const Color(0xFFF59E0B),
                            ),
                            _buildShortcutCard(
                              theme: theme,
                              title: 'Clubs &\nOrganizations',
                              icon: LucideIcons.heart,
                              route: '/club',
                              color: const Color(0xFFEC4899),
                            ),
                            _buildShortcutCard(
                              theme: theme,
                              title: 'Student\nAssociations',
                              icon: LucideIcons.landmark,
                              route: '/association',
                              color: const Color(0xFF0EA5E9),
                            ),
                            _buildShortcutCard(
                              theme: theme,
                              title: 'Blood\nBank',
                              icon: LucideIcons.droplets,
                              route: '/blood-bank',
                              color: const Color(0xFFDC2626),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: Spacing.sm),
                    const SubscriptionSection(),
                    const SizedBox(height: Spacing.sm),
                    const QuickFavoritesSection(),
                    const SizedBox(height: Spacing.sm),
                    const BannerAdWidget(),
                    const SizedBox(height: Spacing.sm),
                    const BannerSection(),
                    const SizedBox(height: Spacing.sm),
                    const SkillUpSection(),
                    const SizedBox(height: Spacing.sm),
                    const MarketplaceSection(),
                    const SizedBox(height: Spacing.sm),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildShortcutCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        width: 96,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: Icon(icon, size: 16, color: color),
            ),

            const SizedBox(height: Spacing.sm),

            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
