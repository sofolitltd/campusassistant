import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/domain/entities/user.dart' as user_entity;
import '/features/reward/presentation/providers/reward_providers.dart';
import '/routes/app_route.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import 'profile_info_tabs.dart';
import 'account_section.dart';
import 'theme_section.dart';
import 'quick_actions_section.dart';
import 'subscription_card.dart';
import '/core/theme/tokens/app_spacing.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key, required this.user});

  final user_entity.User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.lg,
        ),
        child: Column(
          children: [
            if (user.subscriptionStatus == 'pro')
              SubscriptionCard(uid: user.id),
            ProfileInfoTabsSection(user: user),
            const AccountSection(),
            const QuickActionsSection(),
            const ThemeSection(),
            Padding(
              padding: const EdgeInsets.only(top: Spacing.lg),
              child: PreferenceCard(
                children: [
                  PreferenceTile(
                    icon: LucideIcons.coins,
                    title: 'Rewards',
                    trailing: _BalanceChip(),
                    onTap: () => context.push(AppRoute.reward.path),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: Spacing.lg),
              child: PreferenceCard(
                children: [
                  PreferenceTile(
                    icon: LucideIcons.messageSquare,
                    title: 'Feedback',
                    onTap: () => context.push(AppRoute.feedback.path),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceChip extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(rewardBalanceProvider);

    return balanceAsync.when(
      data: (balance) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xxs,
        ),
        decoration: BoxDecoration(
          color: context.colors.warning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(RadiusToken.full),
        ),
        child: Text(
          '${balance.balance}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.colors.warning,
            fontWeight: .w600,
          ),
        ),
      ),
      loading: () => const SizedBox(width: 24, height: 12),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
