import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';

class MarketplaceInfoScreen extends StatelessWidget {
  const MarketplaceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Campus Market')),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeroSection(),
              const SizedBox(height: 24),
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
              const SizedBox(height: 16),
              _SectionCard(
                icon: LucideIcons.badgeCheck,
                title: 'Who Can Buy?',
                children: [
                  'Any registered student, faculty, or staff member of the university can browse and purchase items '
                      'on Campus Market. Simply log in with your campus credentials and start shopping.',
                  'No special approval needed — just find what you need and place your order.',
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                icon: LucideIcons.store,
                title: 'Who Can Sell?',
                children: [
                  'Currently, selling is open to verified campus community members who have applied and been approved as merchants.',
                  'Merchants must be associated with the university (students, faculty, or staff) and agree to '
                      'our terms of service to ensure a safe and trusted marketplace for everyone.',
                ],
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              _TermsPrivacyCard(),
              const SizedBox(height: 32),
            ],
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
      padding: const EdgeInsets.all(24),
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.store, size: 40, color: primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to Campus Market',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Your campus-exclusive marketplace — buy, sell, and connect within your university community.',
            textAlign: TextAlign.center,
            style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, height: 1.5),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: primaryColor),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          for (final child in children) ...[
            Text(child, style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            )),
            if (child != children.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _TermsPrivacyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.shield, size: 22, color: primaryColor),
              const SizedBox(width: 10),
              const Text('Privacy & Terms', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          _TermItem(
            icon: LucideIcons.lock,
            title: 'Privacy Policy',
            description: 'Your personal information is securely stored and never shared with third parties '
                'without your consent. We only use your data to facilitate transactions and '
                'improve your marketplace experience.',
          ),
          const SizedBox(height: 12),
          _TermItem(
            icon: LucideIcons.fileText,
            title: 'Terms & Conditions',
            description: 'By using Campus Market, you agree to abide by university guidelines. '
                'All transactions are between buyer and seller. Campus Assistant facilitates '
                'the connection but is not liable for disputes.',
          ),
          const SizedBox(height: 12),
          _TermItem(
            icon: LucideIcons.ban,
            title: 'Prohibited Items',
            description: 'We strictly prohibit the sale of illegal items, weapons, alcohol, drugs, '
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 4),
              Text(description, style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              )),
            ],
          ),
        ),
      ],
    );
  }
}
