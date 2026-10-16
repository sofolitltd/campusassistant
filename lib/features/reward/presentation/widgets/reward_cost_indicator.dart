import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/core/theme/tokens/app_accents.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/reward/presentation/providers/reward_providers.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class RewardCostIndicator extends ConsumerWidget {
  final String resourceId;
  final int fileSizeBytes;

  /// Solid gold fill with white content, so it stays legible over a thumbnail.
  final bool onImage;

  /// Matches the sizing of the "PRO" badge (card top row, beside the course
  /// code pill) instead of the pill-on-image style: horizontal-only padding,
  /// 10px icon, xxs label text. Takes precedence over [onImage].
  final bool compact;

  const RewardCostIndicator({
    super.key,
    required this.resourceId,
    required this.fileSizeBytes,
    this.onImage = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final costAsync = ref.watch(rewardCostProvider(resourceId));

    return costAsync.when(
      data: (cost) => Container(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: Spacing.sm)
            : const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xxs,
              ),
        alignment: compact ? Alignment.center : null,
        decoration: BoxDecoration(
          color: onImage
              ? AccentToken.gold
              : AccentToken.gold.withValues(alpha: compact ? 0.15 : 0.12),
          borderRadius: BorderRadius.circular(
            compact ? RadiusToken.xs : RadiusToken.full,
          ),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              LucideIcons.coins,
              size: compact ? 10 : 12,
              color: onImage ? Colors.white : AccentToken.gold,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              '$cost',
              style: compact
                  ? TextStyle(
                      height: 1,
                      fontSize: FontSizeToken.xxs,
                      fontWeight: .bold,
                      color: AccentToken.gold,
                    )
                  : Theme.of(context).textTheme.labelSmall?.copyWith(
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
