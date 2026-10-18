import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/providers/perks_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_accents.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/routes/app_route.dart';
import '../../data/models/reward_balance.dart';
import '../providers/reward_providers.dart';

/// Balance at or below which a spend also warns that coins are running out.
const _lowBalanceThreshold = 10;

/// Invisible Home section that explains coins once per account: the welcome
/// bonus is granted silently server-side the first time the balance is
/// fetched, so without this a new user never learns they have coins, or why
/// downloads start showing ads once they run out.
class CoinWelcomeGate extends ConsumerStatefulWidget {
  const CoinWelcomeGate({super.key});

  @override
  ConsumerState<CoinWelcomeGate> createState() => _CoinWelcomeGateState();
}

class _CoinWelcomeGateState extends ConsumerState<CoinWelcomeGate> {
  bool _checked = false;

  Future<void> _maybeShow(String userId, RewardBalance balance) async {
    if (_checked) return;
    _checked = true;

    final storage = ref.read(secureStorageProvider);
    final key = 'coin_welcome_seen_$userId';
    try {
      if (await storage.read(key: key) != null) return;
      await storage.write(key: key, value: '1');
    } catch (_) {
      return; // Storage unavailable — skip rather than nag every launch.
    }
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => _CoinWelcomeSheet(balance: balance),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Coins don't matter while Pro or coin-free; the intro waits (unseen)
    // until a grant ends, which is exactly when it's needed.
    if (!_checked && !ref.watch(isCoinFreeProvider)) {
      final userId = ref.watch(currentUserProvider).value?.id;
      final balance = ref.watch(rewardBalanceProvider).value;
      if (userId != null && balance != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _maybeShow(userId, balance),
        );
      }
    }
    return const SizedBox.shrink();
  }
}

class _CoinWelcomeSheet extends StatelessWidget {
  final RewardBalance balance;

  const _CoinWelcomeSheet({required this.balance});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isFreshBonus = balance.lifetimeSpent == 0 && balance.balance >= 50;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.xl,
          0,
          Spacing.xl,
          Spacing.xl,
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AccentToken.gold.withValues(alpha: .15),
              ),
              child: Icon(LucideIcons.gift, size: 30, color: AccentToken.gold),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              isFreshBonus
                  ? '${balance.balance} free coins for you!'
                  : 'You have ${balance.balance} coins',
              textAlign: .center,
              style: textTheme.titleLarge?.copyWith(fontWeight: .bold),
            ),
            const SizedBox(height: Spacing.xl),
            const _Point(
              icon: LucideIcons.download,
              text: 'Coins skip the ad on downloads — 1 coin per 10 MB.',
            ),
            const _Point(
              icon: LucideIcons.calendarCheck,
              text: 'Claim free coins every day from Home.',
            ),
            const _Point(
              icon: LucideIcons.circlePlay,
              text: 'Watch a video for +1 coin, up to 5 times a day.',
            ),
            const _Point(
              icon: LucideIcons.info,
              text: 'Out of coins? You can still download after a short ad.',
            ),
            const SizedBox(height: Spacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RadiusToken.lg),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoute.reward.path);
              },
              child: const Text('See my coins'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Point({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Icon(icon, size: 20, color: context.colors.primary),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

bool _lowBalanceWarned = false;

/// Tells the user a download just cost coins, so running out later isn't a
/// surprise. Once per app session, the first spend that leaves the balance
/// low swaps the toast for a snackbar pointing at free coins — a snackbar
/// rather than a dialog so it never blocks the download that just started.
void showCoinSpentFeedback(
  BuildContext context, {
  required int spent,
  required int balance,
}) {
  if (spent <= 0) return;

  final messenger = ScaffoldMessenger.maybeOf(context);
  if (balance <= _lowBalanceThreshold &&
      !_lowBalanceWarned &&
      messenger != null) {
    _lowBalanceWarned = true;
    final router = GoRouter.of(context);
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        // A SnackBar with an action persists by default; let it time out so
        // it doesn't follow the user across pages.
        persist: false,
        content: Text(
          '−$spent coins · only $balance left. When coins run out, '
          'downloads show a short ad first.',
        ),
        action: SnackBarAction(
          label: 'Get coins',
          onPressed: () => router.push(AppRoute.reward.path),
        ),
      ),
    );
    return;
  }

  Fluttertoast.showToast(msg: '−$spent coins · $balance left');
}
