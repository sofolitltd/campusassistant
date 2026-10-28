import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/providers/is_pro_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/routes/app_route.dart';
import '../providers/subscription_provider.dart';

/// Home banner nudging renewal once a Pro user's subscription has passed
/// its end date but is still inside the backend's grace window (access
/// keeps working — is_pro stays true server-side — this is purely a nudge).
class GracePeriodBanner extends ConsumerWidget {
  const GracePeriodBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null || !ref.watch(isProUserProvider)) {
      return const SizedBox.shrink();
    }

    final subscription = ref.watch(userSubscriptionProvider(user.id)).value;
    final endDate = subscription?.endDate;
    final graceEndsAt = subscription?.graceEndsAt;
    if (endDate == null || graceEndsAt == null) {
      return const SizedBox.shrink(); // lifetime, or no subscription record
    }
    final now = DateTime.now();
    if (!now.isAfter(endDate) || !now.isBefore(graceEndsAt)) {
      return const SizedBox.shrink(); // not in the grace window
    }

    final daysLeft = graceEndsAt.difference(now).inDays + 1;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
      child: Material(
        color: colors.warningSubtle,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          onTap: () => context.pushNamed(AppRoute.subscription.name),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, color: colors.warning),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Pro access ends soon',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colors.text,
                        ),
                      ),
                      Text(
                        daysLeft <= 1
                            ? 'Renew today to keep it — access ends tomorrow.'
                            : 'Renew now to keep it — $daysLeft days left.',
                        style: TextStyle(color: colors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.warning),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
