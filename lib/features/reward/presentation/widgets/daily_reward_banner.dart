import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_accents.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../providers/reward_providers.dart';

/// Home banner that prompts the user to explicitly claim today's login
/// reward. Status is read-only (never auto-claims); the reward is only
/// granted when the user taps the card.
class DailyRewardBanner extends ConsumerStatefulWidget {
  /// Whether to wrap the card in its own outer padding. Set to false when
  /// the parent already applies padding (e.g. inside a padded ListView).
  final bool padded;

  const DailyRewardBanner({super.key, this.padded = true});

  @override
  ConsumerState<DailyRewardBanner> createState() => _DailyRewardBannerState();
}

class _DailyRewardBannerState extends ConsumerState<DailyRewardBanner> {
  bool _isClaiming = false;

  Future<void> _claim() async {
    if (_isClaiming) return;
    setState(() => _isClaiming = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final result = await ref.read(rewardRepositoryProvider).claimDailyLogin();
      result.fold(
        (failure) => messenger.showSnackBar(
          SnackBar(content: Text('Could not claim reward: ${failure.message}')),
        ),
        (data) {
          final alreadyClaimed = data['already_claimed'] == true;
          final earned = data['earned'] as int? ?? 0;
          ref.invalidate(dailyLoginStatusProvider);
          ref.invalidate(rewardBalanceProvider);
          ref.invalidate(rewardTransactionsProvider);
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                alreadyClaimed
                    ? 'Already claimed today. Come back tomorrow!'
                    : 'You claimed $earned reward coins!',
              ),
            ),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _isClaiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(dailyLoginStatusProvider);

    return statusAsync.when(
      data: (status) {
        final alreadyClaimed = status['already_claimed'] == true;
        if (alreadyClaimed) return const SizedBox.shrink();
        final amount = status['reward_amount'] as int? ?? 2;
        return _Card(
          amount: amount,
          isLoading: _isClaiming,
          padded: widget.padded,
          onTap: _claim,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _Card extends StatelessWidget {
  final int amount;
  final bool isLoading;
  final bool padded;
  final VoidCallback? onTap;

  const _Card({
    required this.amount,
    required this.isLoading,
    required this.padded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const fg = AccentToken.onGold;

    return Padding(
      padding: padded
          ? const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg)
          : const EdgeInsets.only(bottom: Spacing.lg),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AccentToken.goldLight, AccentToken.gold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(RadiusToken.lg),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(RadiusToken.lg),
            onTap: isLoading ? null : onTap,
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(Spacing.sm),
                    decoration: BoxDecoration(
                      color: fg.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.gift, color: fg),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Claim your daily reward',
                          style: TextStyle(fontWeight: FontWeight.bold, color: fg),
                        ),
                        Text(
                          'Tap to collect $amount free reward coins today.',
                          style: TextStyle(
                            color: fg.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: fg),
                    )
                  else
                    const Icon(LucideIcons.chevronRight, color: fg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
