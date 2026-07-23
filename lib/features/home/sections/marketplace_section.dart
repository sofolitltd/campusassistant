import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/routes/app_route.dart';

class MarketplaceSection extends ConsumerWidget {
  const MarketplaceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).appColors.primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: GestureDetector(
        onTap: () => context.push(AppRoute.marketplace.path),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [primaryColor.withValues(alpha: 0.2), primaryColor.withValues(alpha: 0.05)]
                  : [primaryColor.withValues(alpha: 0.1), primaryColor.withValues(alpha: 0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(RadiusToken.lg),
            border: Border.all(
              color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(LucideIcons.shoppingBag, color: primaryColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Campus Marketplace',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _benefitRow(LucideIcons.store, 'Buy & sell with campus sellers'),
                const SizedBox(height: 6),
                _benefitRow(LucideIcons.mapPin, 'Fast pickup on campus'),
                const SizedBox(height: 6),
                _benefitRow(LucideIcons.shield, 'Secure payment via bKash'),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Explore Marketplace',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _benefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
