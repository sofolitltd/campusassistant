import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/routes/app_route.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
      child: Row(
        children: items
            .map(
              (item) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: item == items.last ? 0 : 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(RadiusToken.lg),
                    border: Border.all(color: context.colors.border),
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.shadow,
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
                          vertical: Spacing.xl,
                          horizontal: Spacing.md,
                        ),
                        child: Column(
                          mainAxisSize: .min,
                          children: [
                            Icon(
                              item.icon,
                              size: 24,
                              color: context.colors.primary,
                            ),
                            const SizedBox(height: Spacing.md),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: FontSizeToken.md,
                                fontWeight: .w500,
                                color: context.colors.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
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
