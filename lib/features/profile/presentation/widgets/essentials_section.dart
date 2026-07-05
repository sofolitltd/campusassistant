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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                'Essentials',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 4),
            ListTile(
              onTap: () => context.push(AppRoute.mySubmissions.path),
              leading: Icon(
                LucideIcons.fileText,
                color: isDark ? Colors.white70 : Colors.black87,
                size: 20,
              ),
              title: Text(
                'My Submissions',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.grey.shade300,
            ),
            ListTile(
              onTap: () => context.push(AppRoute.noticeGroup.path, extra: user),
              leading: Icon(
                LucideIcons.megaphone,
                color: isDark ? Colors.white70 : Colors.black87,
                size: 20,
              ),
              title: Text(
                'Notice Group',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
