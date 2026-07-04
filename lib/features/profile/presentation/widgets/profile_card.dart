import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusassistant/features/auth/domain/entities/user.dart'
    as user_entity;
import 'header_card.dart';
import 'academic_section.dart';
import 'contact_section.dart';
import 'account_section.dart';
import 'theme_section.dart';
import 'essentials_section.dart';
import 'subscription_card.dart';
import 'package:campusassistant/core/theme/tokens/app_spacing.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key, required this.user});

  final user_entity.User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            HeaderCard(user: user),
            if (user.subscriptionStatus == 'pro')
              SubscriptionCard(uid: user.id),
            if (user.role == 'student')
              AcademicSection(user: user),
            ContactSection(user: user),
            const SizedBox(height: Spacing.lg),
            const AccountSection(),
            const SizedBox(height: 8),
            const ThemeSection(),
            EssentialsSection(user: user),
          ],
        ),
      ),
    );
  }
}
