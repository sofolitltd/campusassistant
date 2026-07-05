import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusassistant/features/auth/domain/entities/user.dart'
    as user_entity;
import 'profile_info_tabs.dart';
import 'account_section.dart';
import 'theme_section.dart';
import 'essentials_section.dart';
import 'subscription_card.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key, required this.user});

  final user_entity.User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            if (user.subscriptionStatus == 'pro')
              SubscriptionCard(uid: user.id),
            ProfileInfoTabsSection(user: user),
            const AccountSection(),
            const ThemeSection(),
            EssentialsSection(user: user),
          ],
        ),
      ),
    );
  }
}
