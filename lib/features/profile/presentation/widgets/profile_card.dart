import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusassistant/features/auth/domain/entities/user.dart'
    as user_entity;
import 'header_card.dart';
import 'profile_info_tabs.dart';
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
            const AccountSection(),
            const SizedBox(height: 16),
            if (user.subscriptionStatus == 'pro')
              SubscriptionCard(uid: user.id),
            ProfileInfoTabsSection(user: user),
            const SizedBox(height: 16),
            const ThemeSection(),
            const SizedBox(height: 16),
            EssentialsSection(user: user),
          ],
        ),
      ),
    );
  }
}
