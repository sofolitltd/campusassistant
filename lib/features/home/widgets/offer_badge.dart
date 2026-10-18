import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/providers/is_pro_provider.dart';
import '/core/providers/perks_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import 'home_section.dart';

/// Days before an offer ends at which the badge turns into a heads-up.
const _endingSoonDays = 3;

/// Home strip shown while an access grant (campus launch offer, exam-season
/// promo, …) covers the user: says what's free and for how long, and in the
/// last few days warns that coins take over afterwards — so ads returning
/// is never a surprise. Hidden for Pro (their perks aren't an offer).
class OfferBadge extends ConsumerWidget {
  const OfferBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perks = ref.watch(grantPerksProvider);
    if (!perks.any || ref.watch(isProUserProvider)) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final endsAt = perks.endsAt;
    final daysLeft = endsAt?.difference(DateTime.now()).inHours;
    final days = daysLeft == null ? null : (daysLeft / 24).ceil();
    final endingSoon = days != null && days <= _endingSoonDays;

    final what = [
      if (perks.adFree) 'No ads',
      if (perks.coinFree) 'free downloads',
    ].join(' · ');
    final when = days == null
        ? 'no end date'
        : days <= 1
        ? 'last day'
        : '$days days left';

    final fg = endingSoon ? colors.warning : colors.success;

    return HomeSection(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: homeInset),
        child: Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: endingSoon ? colors.warningSubtle : colors.successSubtle,
            borderRadius: BorderRadius.circular(homeCardRadius),
          ),
          child: Row(
            children: [
              Icon(
                endingSoon ? LucideIcons.hourglass : LucideIcons.partyPopper,
                color: fg,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      perks.label.isEmpty ? 'Special offer' : perks.label,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: .bold,
                        color: fg,
                      ),
                    ),
                    Text(
                      endingSoon
                          ? '$what · $when. After that, coins skip the ads.'
                          : '$what · $when',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
