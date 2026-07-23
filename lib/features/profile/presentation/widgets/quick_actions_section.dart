import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';
import '/features/career/presentation/screens/career_page.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      _ActionItem(
        icon: LucideIcons.megaphone,
        label: 'Notice Group',
        onTap: () => context.push('/department/notices'),
      ),
      _ActionItem(
        icon: LucideIcons.inbox,
        label: 'Inbox',
        onTap: () => context.push(AppRoute.inbox.path),
      ),
      _ActionItem(
        icon: LucideIcons.users,
        label: 'My Clubs',
        onTap: () => context.push(AppRoute.myClubs.path),
      ),
      _ActionItem(
        icon: LucideIcons.briefcase,
        label: 'Job Posts',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CareerPage(initialTab: 1)),
        ),
      ),
      _ActionItem(
        icon: LucideIcons.bell,
        label: 'Dates Reminder',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CareerPage(initialTab: 2)),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 96,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          itemBuilder: (context, index) {
            final item = items[index];
            return SizedBox(
              width: 96,
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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(RadiusToken.lg),
                    onTap: item.onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            size: 24,
                            color: Theme.of(context).appColors.primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
