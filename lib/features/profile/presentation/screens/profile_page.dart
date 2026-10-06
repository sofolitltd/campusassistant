import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/tokens/app_spacing.dart';
import '../../../../routes/app_route.dart';
import '../../../../routes/scaffold_with_navbar.dart';
import '../../../reward/presentation/providers/reward_providers.dart';
import '../widgets/header_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_completion_card.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_font_size.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final primaryColor = context.colors.primary;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        actions: [
          _AppBarRewardBadge(),
          Padding(
            padding: const EdgeInsets.only(right: Spacing.sm),
            child: GestureDetector(
              onTap: () =>
                  ScaffoldWithNavBar.scaffoldKey.currentState?.openDrawer(),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: context.colors.surface.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(Spacing.xs),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusToken.lg),
                  child: Image.asset('assets/images/logo.png', fit: .contain),
                ),
              ),
            ),
          ),
        ],
        title: Text(
          'Profile',
          style: TextStyle(
            color: context.colors.onPrimary,
            fontWeight: .bold,
            fontSize: FontSizeToken.xxl,
          ),
        ),
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }
          final isProfileComplete = profileCompletionPercent(user) == 100;
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).scaffoldBackgroundColor
                        : context.colors.surfaceAlt,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(RadiusToken.xxxl),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(RadiusToken.xxxl),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: Spacing.lg),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Spacing.lg),
                          child: HeaderCard(user: user),
                        ),
                        // Once the profile is 100% complete, the header
                        // badge already shows "100%" — this card's only job
                        // was nudging the user to finish, so it has nothing
                        // left to say.
                        if (!isProfileComplete) ...[
                          const SizedBox(height: Spacing.md),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spacing.lg,
                            ),
                            child: ProfileCompletionCard(user: user),
                          ),
                        ],
                        ProfileCard(user: user),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}

class _AppBarRewardBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(rewardBalanceProvider);

    return GestureDetector(
      onTap: () => context.push(AppRoute.reward.path),
      child: Padding(
        padding: const EdgeInsets.only(right: Spacing.md),
        child: balanceAsync.when(
          data: (balance) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: context.colors.warning,
              borderRadius: BorderRadius.circular(RadiusToken.full),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  LucideIcons.coins,
                  size: 14,
                  color: context.colors.onPrimary,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  '${balance.balance}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: .w600,
                  ),
                ),
              ],
            ),
          ),
          loading: () => const SizedBox(width: 32, height: 24),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
