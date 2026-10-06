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
    // The market's own orange palette (same hero look as the market home), so
    // the card stands out from the teal home page.
    final m = Theme.of(context).brightness == Brightness.dark
        ? AppColors.marketDark
        : AppColors.marketLight;

    return HomeSection(
      child: SectionCard(
        margin: const EdgeInsets.fromLTRB(homeInset, Spacing.lg, homeInset, 0),
        radius: homeCardRadius,
        padding: EdgeInsets.zero,
        gradient: LinearGradient(
          colors: [m.primary, m.primaryPressed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderColor: Colors.transparent,
        shadow: false,
        onTap: () => context.push(AppRoute.marketplace.path),
        child: Stack(
          children: [
            Positioned(
              right: -36,
              top: -36,
              child: _Ring(
                size: 150,
                color: m.onPrimary.withValues(alpha: .08),
              ),
            ),
            Positioned(
              right: 24,
              bottom: -52,
              child: _Ring(
                size: 110,
                color: m.onPrimary.withValues(alpha: .06),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: m.onPrimary.withValues(alpha: .18),
                          borderRadius: BorderRadius.circular(RadiusToken.md),
                        ),
                        child: Icon(
                          LucideIcons.store,
                          size: 18,
                          color: m.onPrimary,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Text(
                          'Campus Marketplace',
                          style: TextStyle(
                            fontSize: FontSizeToken.display,
                            fontWeight: .w800,
                            letterSpacing: -0.2,
                            color: m.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.lg),
                  for (final b in _benefits) ...[
                    Row(
                      children: [
                        Icon(LucideIcons.check, size: 14, color: m.onPrimary),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            b,
                            style: TextStyle(
                              fontSize: FontSizeToken.md,
                              color: m.onPrimary.withValues(alpha: .88),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs + 2),
                  ],
                  const SizedBox(height: Spacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.xl,
                      vertical: Spacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: m.onPrimary,
                      borderRadius: BorderRadius.circular(RadiusToken.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Explore Marketplace',
                          style: TextStyle(
                            color: m.primary,
                            fontWeight: .w700,
                            fontSize: FontSizeToken.base,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Icon(
                          LucideIcons.arrowRight,
                          size: 16,
                          color: m.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
