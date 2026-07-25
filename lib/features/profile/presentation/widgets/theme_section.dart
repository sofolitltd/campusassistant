import 'package:campusassistant/core/theme/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeProvider).value ?? ThemeMode.system;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context, 'Appearance'),
          const SizedBox(height: 8),
          _PreferenceCard(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.palette,
                          color: isDark
                              ? Colors.white70
                              : Theme.of(context).appColors.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'App Theme',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1,
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _ThemeSegmentedControl(currentMode: themeMode),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _sectionTitle(context, 'Account'),
          const SizedBox(height: 8),
          _PreferenceCard(
            children: [
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
              _PreferenceTile(
                icon: LucideIcons.receiptText,
                title: 'Transaction History',
                onTap: () {
                  context.pushNamed(AppRoute.transactionHistory.name);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _sectionTitle(context, 'Notifications'),
          const SizedBox(height: 8),
          _PreferenceCard(
            children: [
              _PreferenceTile(
                icon: LucideIcons.bellRing,
                title: 'Notification Settings',
                onTap: () {
                  context.pushNamed(AppRoute.notificationSettings.name);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _sectionTitle(context, 'Security'),
          const SizedBox(height: 8),
          _PreferenceCard(
            children: [
              _PreferenceTile(
                icon: LucideIcons.lockKeyhole,
                title: 'Change Password',
                onTap: () {
                  context.pushNamed(AppRoute.changePassword.name);
                },
              ),
              _PreferenceTile(
                icon: LucideIcons.smartphone,
                title: 'Manage Devices',
                onTap: () {
                  context.pushNamed(AppRoute.manageDevices.name);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _sectionTitle(context, 'Data'),
          const SizedBox(height: 8),
          _PreferenceCard(
            children: [
              _PreferenceTile(
                icon: LucideIcons.database,
                title: 'Manage Cache',
                onTap: () {
                  context.pushNamed(AppRoute.cacheManagement.name);
                },
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.grey.shade800,
        ),
      ),
    );
  }

}

class _PreferenceCard extends StatelessWidget {
  final List<Widget> children;

  const _PreferenceCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
        children: List.generate(children.length, (i) {
          return Column(
            children: [
              if (i > 0)
                Divider(
                  height: 1,
                  color: isDark ? Colors.white10 : Colors.grey.shade300,
                ),
              children[i],
            ],
          );
        }),
      ),
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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:const EdgeInsets.fromLTRB(16,16,12,16),
        child: Row(
          spacing: 12,
          children: [
            Icon(
              icon,
              color: isDark
                  ? Colors.white70
                  : Theme.of(context).appColors.primaryColor,
              size: 18,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  height: 1,
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSegmentedControl extends ConsumerWidget {
  final ThemeMode currentMode;

  const _ThemeSegmentedControl({required this.currentMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final segments = [
      (icon: LucideIcons.sun, label: 'Light', mode: ThemeMode.light),
      (icon: LucideIcons.moon, label: 'Dark', mode: ThemeMode.dark),
      (icon: LucideIcons.monitor, label: 'System', mode: ThemeMode.system),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHighest
            : cs.outlineVariant.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(segments.length, (i) {
          final segment = segments[i];
          final selected = currentMode == segment.mode;
          return Expanded(
            child: GestureDetector(
              onTap: selected
                  ? null
                  : () => ref
                      .read(themeProvider.notifier)
                      .setTheme(segment.mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: 34,
                decoration: BoxDecoration(
                  color: selected ? Theme.of(context).appColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Icon(
                      segment.icon,
                      size: 13,
                      color: selected
                          ? cs.onPrimary
                          : cs.onSurfaceVariant,
                    ),
                    Text(
                      segment.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                        color: selected
                            ? cs.onPrimary
                            : cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
