import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '/core/ads/rewarded_ad_manager.dart';
import '/core/providers/is_pro_provider.dart';
import '/routes/app_route.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '../providers/reward_providers.dart';
import '/core/theme/tokens/app_spacing.dart';

class RewardPage extends ConsumerStatefulWidget {
  const RewardPage({super.key});

  @override
  ConsumerState<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends ConsumerState<RewardPage> {
  int _offset = 0;
  bool _isClaiming = false;

  @override
  void initState() {
    super.initState();
    // Warm up an ad so the button is ready by the time the user taps it.
    ref.read(rewardedAdManagerProvider).preload();
  }

  Future<void> _watchAdForReward() async {
    if (_isClaiming) return;
    setState(() => _isClaiming = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final watched = await ref.read(rewardedAdManagerProvider).show();
      if (!watched) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Ad not available right now. Please try again shortly.'),
          ),
        );
        return;
      }

      final result = await ref.read(rewardRepositoryProvider).earn();
      result.fold(
        (failure) => messenger.showSnackBar(
          SnackBar(content: Text('Could not add reward: ${failure.message}')),
        ),
        (_) {
          _offset = 0;
          ref.invalidate(rewardBalanceProvider);
          ref.invalidate(rewardTransactionsProvider);
          messenger.showSnackBar(
            const SnackBar(content: Text('You earned 1 reward coin!')),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _isClaiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final balanceAsync = ref.watch(rewardBalanceProvider);
    final transactionsAsync = ref.watch(rewardTransactionsProvider(_offset));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          balanceAsync.when(
            data: (balance) => _BalanceCard(balance: balance),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(Spacing.xxxl),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xxxl),
                child: Text('Failed to load balance: $err'),
              ),
            ),
          ),
          if (!kIsWeb && !ref.watch(isProUserProvider)) ...[
            const SizedBox(height: Spacing.lg),
            _WatchAdCard(
              isLoading: _isClaiming,
              onPressed: _watchAdForReward,
            ),
          ],
          if (!ref.watch(isProUserProvider)) ...[
            const SizedBox(height: Spacing.md),
            _GoProCard(
              onPressed: () =>
                  context.pushNamed(AppRoute.subscription.name),
            ),
          ],
          const SizedBox(height: Spacing.xxl),
          Text(
            'Transaction History',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: .w600,
                ),
          ),
          const SizedBox(height: Spacing.md),
          transactionsAsync.when(
            data: (result) {
              if (result.data.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.xxxl),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          LucideIcons.receipt,
                          size: 48,
                          color: context.colors.textSubtle,
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          'No transactions yet',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: context.colors.textSubtle,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  ...result.data.map(
                    (txn) => _TransactionTile(transaction: txn),
                  ),
                  if (result.data.length >= 20)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
                      child: TextButton(
                        onPressed: () {
                          setState(() => _offset += 20);
                        },
                        child: const Text('Load more'),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(Spacing.xxxl),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xxxl),
                child: Text('Failed to load transactions: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final dynamic balance;

  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(Spacing.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.warning,
            context.colors.warning.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.coins,
            size: 48,
            color: context.colors.bg,
          ),
          const SizedBox(height: Spacing.md),
          Text(
            '${balance.balance}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: context.colors.bg,
                  fontWeight: .bold,
                ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            'Reward Coins',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.bg.withValues(alpha: 0.9),
                ),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            mainAxisAlignment: .center,
            children: [
              _Stat(
                label: 'Earned',
                value: '${balance.lifetimeEarned}',
                color: context.colors.bg,
              ),
              const SizedBox(width: Spacing.xxxl),
              _Stat(
                label: 'Spent',
                value: '${balance.lifetimeSpent}',
                color: context.colors.bg,
              ),
            ],
          ),
        ],
      ),
    );
}

class _WatchAdCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _WatchAdCard({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: context.colors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            child: Icon(
              LucideIcons.circlePlay,
              color: context.colors.warning,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Watch an ad, earn 1 coin',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: .w600,
                      ),
                ),
                Text(
                  'Watch a short video to get a free reward coin.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textSubtle,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Watch'),
          ),
        ],
      ),
    );
}

class _GoProCard extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoProCard({required this.onPressed});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
            child: Icon(
              LucideIcons.crown,
              color: context.colors.success,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Skip the ads, go Pro',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: .w600,
                      ),
                ),
                Text(
                  'Unlimited ad-free downloads, no coins needed.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textSubtle,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          OutlinedButton(
            onPressed: onPressed,
            child: const Text('Go Pro'),
          ),
        ],
      ),
    );
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Stat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: .bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withValues(alpha: 0.8),
              ),
        ),
      ],
    );
}

class _TransactionTile extends StatelessWidget {
  final dynamic transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isEarn = transaction.type == 'earn';
    final dateStr = transaction.createdAt != null
        ? DateFormat('MMM d, yyyy').format(transaction.createdAt)
        : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: (isEarn
                        ? context.colors.success
                        : context.colors.danger)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(RadiusToken.md),
              ),
              child: Icon(
                isEarn ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                size: 16,
                color: isEarn
                    ? context.colors.success
                    : context.colors.danger,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    transaction.description ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: .w500,
                        ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  if (dateStr.isNotEmpty)
                    Text(
                      dateStr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.colors.textSubtle,
                          ),
                    ),
                ],
              ),
            ),
            Text(
              '${isEarn ? '+' : '-'}${transaction.amount}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: .bold,
                    color: isEarn
                        ? context.colors.success
                        : context.colors.danger,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
