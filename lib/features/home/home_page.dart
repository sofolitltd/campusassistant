import 'package:campusassistant/core/theme/tokens/app_spacing.dart';
import 'package:campusassistant/features/notification/presentation/widgets/notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';
import '../../features/auth/presentation/providers/user_profile_provider.dart';
import 'sections/banner_section.dart';
import 'sections/subscription_section.dart';
import 'sections/quick_favorites_section.dart';
import 'widgets/home_drawer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
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
              decoration: const BoxDecoration(color: Color(0xFFD32F2F)),
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
                              backgroundColor: Colors.white.withOpacity(0.2),
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
                                onTap: () => context.push(
                                  AppRoute.notifications.path,
                                ),
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
                              color: Colors.white.withOpacity(0.9),
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
                    SizedBox(height: Spacing.sm),

                    // Shortcut Cards
                    SizedBox(
                      height: 96,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        children: [
                          _buildShortcutCard(
                            theme: theme,
                            title: 'Routine',
                            subtitle: 'View class schedule',
                            icon: LucideIcons.calendarDays,
                            route: '/routine',
                            color: const Color(0xFF3B82F6),
                          ),
                          _buildShortcutCard(
                            theme: theme,
                            title: 'Alumni',
                            subtitle: 'Connect with alumni',
                            icon: LucideIcons.graduationCap,
                            route: '/alumni',
                            color: const Color(0xFF8B5CF6),
                          ),
                          _buildShortcutCard(
                            theme: theme,
                            title: 'Emergency',
                            subtitle: 'Important contacts',
                            icon: LucideIcons.phoneCall,
                            route: '/emergency',
                            color: const Color(0xFFEF4444),
                          ),
                          _buildShortcutCard(
                            theme: theme,
                            title: 'Transport',
                            subtitle: 'Bus schedules',
                            icon: LucideIcons.bus,
                            route: '/transport',
                            color: const Color(0xFFF59E0B),
                          ),
                          _buildShortcutCard(
                            theme: theme,
                            title: 'Clubs',
                            subtitle: 'Explore organizations',
                            icon: LucideIcons.heart,
                            route: '/club',
                            color: const Color(0xFFEC4899),
                          ),
                          _buildShortcutCard(
                            theme: theme,
                            title: 'Blood Bank',
                            subtitle: 'Donate or request',
                            icon: LucideIcons.droplets,
                            route: '/blood-bank',
                            color: const Color(0xFFDC2626),
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
                    const SizedBox(height: Spacing.sm),
                    const SubscriptionSection(),
                    const SizedBox(height: Spacing.sm),
                    const QuickFavoritesSection(),
                    const SizedBox(height: Spacing.sm),
                    const BannerSection(),
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
    required String subtitle,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 2),
              isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: isDark ? Colors.white54 : Colors.grey.shade400,
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Icon(icon, size: 14, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
