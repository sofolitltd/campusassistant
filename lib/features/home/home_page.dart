import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/notification/presentation/widgets/notification_badge.dart';
import '/widgets/custom_drawer.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../banner/presentation/providers/banner_provider.dart';
import 'sections/banner_section.dart';
import 'sections/subscription_section.dart';
import 'sections/shortcut_section.dart';
import 'sections/explore_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleSpacing: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(LucideIcons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: Image.asset('assets/images/splash.png', height: 30),
        actions: [
          NotificationBadge(
            icon: const Icon(LucideIcons.bell),
            onTap: () => context.push('/notifications'),
          ),
          const SizedBox(width: Spacing.md),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF020617)]
                : [const Color(0xFFFDFCFB), const Color(0xFFEEF2FF)],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            final _ = ref.refresh(bannersListProvider);
            await ref.read(bannersListProvider.future);
          },
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Spacing.lg),
                BannerSection(),
                SubscriptionSection(),
                ShortcutSection(),
                SizedBox(height: Spacing.lg),
                ExploreSection(),
                SizedBox(height: Spacing.lg),
              ],
            ),
          ),
        ),
        ),
      
    );
  }
}
