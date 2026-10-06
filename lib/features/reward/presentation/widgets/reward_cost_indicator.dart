import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/reward/presentation/providers/reward_providers.dart';
import '/core/theme/tokens/app_spacing.dart';

class RewardCostIndicator extends ConsumerWidget {
  final String resourceId;
  final int fileSizeBytes;

  const RewardCostIndicator({
    super.key,
    required this.resourceId,
    required this.fileSizeBytes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final costAsync = ref.watch(rewardCostProvider(resourceId));

    return costAsync.when(
      data: (cost) => Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xxs),
        decoration: BoxDecoration(
          color: context.colors.warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(RadiusToken.full),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.coins,
              size: 12,
              color: context.colors.warning,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              '$cost',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.colors.warning,
                    fontWeight: .w600,
                  ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(width: 36, height: 16),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}