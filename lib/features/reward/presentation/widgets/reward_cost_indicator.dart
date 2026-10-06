import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/theme/tokens/app_accents.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/reward/presentation/providers/reward_providers.dart';
import '/core/theme/tokens/app_spacing.dart';

class RewardCostIndicator extends ConsumerWidget {
  final String resourceId;
  final int fileSizeBytes;

  /// Solid gold fill with white content, so it stays legible over a thumbnail.
  final bool onImage;

  const RewardCostIndicator({
    super.key,
    required this.resourceId,
    required this.fileSizeBytes,
    this.onImage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final costAsync = ref.watch(rewardCostProvider(resourceId));

    return costAsync.when(
      data: (cost) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xxs,
        ),
        decoration: BoxDecoration(
          color: onImage
              ? AccentToken.gold
              : AccentToken.gold.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(RadiusToken.full),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.coins,
              size: 12,
              color: onImage ? Colors.white : AccentToken.gold,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              '$cost',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: onImage ? Colors.white : AccentToken.gold,
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
