import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '../providers/reward_providers.dart';
import '/core/theme/tokens/app_spacing.dart';

class RewardBadge extends ConsumerWidget {
  const RewardBadge({super.key});

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
          border: Border.all(
            color: context.colors.warning.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.coins,
              size: 14,
              color: context.colors.warning,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              '${balance.balance}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: .w600,
                    color: context.colors.warning,
                  ),
            ),
          ],
        ),
      ),
      loading: () => Container(
        width: 48,
        height: 20,
        decoration: BoxDecoration(
          color: context.colors.surfaceAlt,
          borderRadius: BorderRadius.circular(RadiusToken.full),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
