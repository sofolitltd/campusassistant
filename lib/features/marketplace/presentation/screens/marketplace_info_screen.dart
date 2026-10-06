import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '../widgets/market_theme.dart';

class MarketplaceInfoScreen extends StatelessWidget {
  const MarketplaceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Campus Market')),
      backgroundColor: context.colors.primary,
      body: MarketBody(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.all(Spacing.lg),
              children: [
                _HeroSection(),
                const SizedBox(height: Spacing.xxl),
                _SectionCard(
                  icon: LucideIcons.info,
                  title: 'What is Campus Market?',
                  children: [
                    'Campus Market is a campus-exclusive marketplace built for students, faculty, and staff. '
                        'It allows members of the university community to buy and sell items within the campus — '
                        'from used textbooks and electronics to handmade crafts, services, and more.',
                    'Think of it as your local campus canteen for everything you need, run by the people you trust — '
                        'your fellow students and campus community members.',
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                _SectionCard(
                  icon: LucideIcons.badgeCheck,
                  title: 'Who Can Buy?',
                  children: [
                    'Any registered student, faculty, or staff member of the university can browse and purchase items '
                        'on Campus Market. Simply log in with your campus credentials and start shopping.',
                    'No special approval needed — just find what you need and place your order.',
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                _SectionCard(
                  icon: LucideIcons.store,
                  title: 'Who Can Sell?',
                  children: [
                    'Currently, selling is open to verified campus community members who have applied and been approved as merchants.',
                    'Merchants must be associated with the university (students, faculty, or staff) and agree to '
                        'our terms of service to ensure a safe and trusted marketplace for everyone.',
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                _SectionCard(
                  icon: LucideIcons.userRoundPlus,
                  title: 'How to Become a Merchant?',
                  children: [
                    '1. Go to the Account tab in the marketplace bottom navigation.',
                    '2. Tap on "Become a Merchant" and fill out the application form.',
                    '3. Provide your details including your name, student/faculty ID, and contact information.',
                    '4. Submit your application for review.',
                    '5. Once approved, you can start listing your products for sale immediately.',
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                _SectionCard(
                  icon: LucideIcons.creditCard,
                  title: 'Payment System',
                  children: [
                    'Payments are processed securely through bKash, Bangladesh\'s leading mobile financial service.',
                    'When you place an order, you will receive payment instructions via the app. '
                        'Simply complete the payment through your bKash account and the merchant will be notified to process your order.',
                    'All transactions are tracked within the app for your reference and records.',
                  ],
                ),
                const SizedBox(height: Spacing.xxl),
                _TermsPrivacyCard(),
                const SizedBox(height: Spacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(Spacing.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: isDark ? 0.25 : 0.12),
            primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.15),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.store, size: 40, color: primaryColor),
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            'Welcome to Campus Market',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: .bold),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            'Your campus-exclusive marketplace — buy, sell, and connect within your university community.',
            textAlign: .center,
            style: TextStyle(color: context.colors.textMuted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: primaryColor),
              const SizedBox(width: Spacing.md),
              Text(
                title,
                style: const TextStyle(
                  fontSize: FontSizeToken.xl,
                  fontWeight: .bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          for (final child in children) ...[
            Text(
              child,
              style: TextStyle(
                fontSize: FontSizeToken.base,
                height: 1.6,
                color: context.colors.textMuted,
              ),
            ),
            if (child != children.last) const SizedBox(height: Spacing.sm),
          ],
        ],
      ),
    );
  }
}

class _TermsPrivacyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.shield, size: 22, color: primaryColor),
              const SizedBox(width: Spacing.md),
              const Text(
                'Privacy & Terms',
                style: TextStyle(fontSize: FontSizeToken.xl, fontWeight: .bold),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          _TermItem(
            icon: LucideIcons.lock,
            title: 'Privacy Policy',
            description:
                'Your personal information is securely stored and never shared with third parties '
                'without your consent. We only use your data to facilitate transactions and '
                'improve your marketplace experience.',
          ),
          const SizedBox(height: Spacing.md),
          _TermItem(
            icon: LucideIcons.fileText,
            title: 'Terms & Conditions',
            description:
                'By using Campus Market, you agree to abide by university guidelines. '
                'All transactions are between buyer and seller. Campus Assistant facilitates '
                'the connection but is not liable for disputes.',
          ),
          const SizedBox(height: Spacing.md),
          _TermItem(
            icon: LucideIcons.ban,
            title: 'Prohibited Items',
            description:
                'We strictly prohibit the sale of illegal items, weapons, alcohol, drugs, '
                'and any items that violate university policies.',
          ),
        ],
      ),
    );
  }
}

class _TermItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TermItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Icon(icon, size: 18, color: context.colors.textMuted),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: .w600,
                  fontSize: FontSizeToken.base,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                description,
                style: TextStyle(
                  fontSize: FontSizeToken.md,
                  height: 1.5,
                  color: context.colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
