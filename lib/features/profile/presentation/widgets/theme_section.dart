import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/providers/theme_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_radius.dart';

class ThemeSection extends ConsumerWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).value ?? ThemeMode.system;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
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
                'My Preferences',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 4),
            _PreferenceTile(
              icon: LucideIcons.palette,
              title: 'App Theme',
              onTap: () => _showThemeModal(context, ref, themeMode),
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.grey.shade300,
            ),
            _PreferenceTile(
              icon: LucideIcons.lockKeyhole,
              title: 'Change Password',
              onTap: () {
                context.pushNamed(AppRoute.changePassword.name);
              },
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.grey.shade300,
            ),
            _PreferenceTile(
              icon: LucideIcons.smartphone,
              title: 'Manage Devices',
              onTap: () {
                context.pushNamed(AppRoute.manageDevices.name);
              },
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.grey.shade300,
            ),
            _PreferenceTile(
              icon: LucideIcons.database,
              title: 'Manage Cache',
              onTap: () {
                context.pushNamed(AppRoute.cacheManagement.name);
              },
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.grey.shade300,
            ),
            _PreferenceTile(
              icon: LucideIcons.receiptText,
              title: 'Transaction History',
              onTap: () {
                context.pushNamed(AppRoute.transactionHistory.name);
              },
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.grey.shade300,
            ),
            _PreferenceTile(
              icon: LucideIcons.userPen,
              title: 'Edit Profile',
              onTap: () {
                final uid = ref.watch(userProvider).value?.uid;
                if (uid != null) {
                  context.pushNamed(
                    AppRoute.editProfile.name,
                    queryParameters: {'uid': uid},
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeModal(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'App Theme',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(LucideIcons.x, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _ThemeOptionTile(
                title: 'Light Theme',
                isSelected: currentMode == ThemeMode.light,
                onTap: () {
                  ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              _ThemeOptionTile(
                title: 'Dark Theme',
                isSelected: currentMode == ThemeMode.dark,
                onTap: () {
                  ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              _ThemeOptionTile(
                title: 'System Default',
                isSelected: currentMode == ThemeMode.system,
                onTap: () {
                  ref.read(themeProvider.notifier).setTheme(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? Colors.white70 : Colors.black87,
        size: 20,
      ),
      title: Text(
        title,
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
      onTap: onTap,
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? (isDark
                  ? Colors.red.shade900.withValues(alpha: 0.2)
                  : Colors.red.shade50)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                LucideIcons.checkCircle,
                color: Colors.red.shade600,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
