import 'package:campusassistant/features/home/sections/subscription_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/notification/presentation/widgets/notification_badge.dart';
import '/widgets/custom_drawer.dart';
import '../banner/presentation/providers/banner_provider.dart';
import 'sections/banner_section.dart';
import 'sections/explore_section.dart';
import 'sections/shortcut_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
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
          const SizedBox(width: 12),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Manual refresh for banner logic
          final _ = ref.refresh(bannersListProvider);
          // Wait for the async task to complete for smooth animation
          await ref.read(bannersListProvider.future);
        },
        child: const SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(), // Ensure refresh indicator works when content is small
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              BannerSection(),
              SubscriptionSection(),

              ShortcutSection(),
              SizedBox(height: 16),

              ExploreSection(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
