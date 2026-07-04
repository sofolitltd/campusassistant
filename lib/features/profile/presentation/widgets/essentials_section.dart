import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:campusassistant/features/auth/domain/entities/user.dart'
    as user_entity;
import 'package:campusassistant/routes/app_route.dart';
import 'section_header.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';

class EssentialsSection extends StatelessWidget {
  final user_entity.User user;

  const EssentialsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          SectionHeader(
            title: 'Essentials',
            subtitle: 'Notice Group, Bookmarks',
            icon: LucideIcons.layers,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).cardColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(RadiusToken.md),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () => context.push(AppRoute.mySubmissions.path),
                  title: const Text('My Submissions'),
                  trailing: const Icon(LucideIcons.cloudUpload, size: 16),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  onTap: () =>
                      context.push(AppRoute.noticeGroup.path, extra: user),
                  title: const Text('Notice Group'),
                  trailing: const Icon(LucideIcons.chevronRight, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
