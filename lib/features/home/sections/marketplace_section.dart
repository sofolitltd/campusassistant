import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_card.dart';
import '/routes/app_route.dart';
import '../widgets/home_section.dart';
import '/core/theme/tokens/app_font_size.dart';

class MarketplaceSection extends StatelessWidget {
  const MarketplaceSection({super.key});

  static const _benefits = [
    'Buy & sell with campus sellers',
    'Fast pickup on campus',
    'Secure payment via bKash',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return HomeSection(
      child: SectionCard(
        margin: const EdgeInsets.symmetric(horizontal: homeInset),
        radius: homeCardRadius,
        gradient: LinearGradient(
          colors: [colors.primarySubtle, colors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderColor: colors.primary.withValues(alpha: .25),
        shadow: false,
        onTap: () => context.push(AppRoute.marketplace.path),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const HomeSectionHeader(
              'Campus Marketplace',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: Spacing.md),
            for (final b in _benefits) ...[
              Row(
                children: [
                  Icon(LucideIcons.check, size: 14, color: colors.primary),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      b,
                      style: TextStyle(
                        fontSize: FontSizeToken.md,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs + 2),
            ],
            const SizedBox(height: Spacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: Spacing.md),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(RadiusToken.md),
              ),
              child: Text(
                'Explore Marketplace',
                textAlign: .center,
                style: TextStyle(
                  color: colors.onPrimary,
                  fontWeight: .bold,
                  fontSize: FontSizeToken.base,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
