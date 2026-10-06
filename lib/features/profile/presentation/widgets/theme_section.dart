import 'package:campusassistant/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/providers/theme_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class ThemeSection extends ConsumerWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeProvider).value ?? ThemeMode.system;

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _sectionTitle(context, 'Appearance'),
            const SizedBox(height: Spacing.sm),
            PreferenceCard(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.lg,
                    Spacing.lg,
                    Spacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.palette,
                            color: isDark
                                ? context.colors.textMuted
                                : context.colors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: Spacing.md),
                          Text(
                            'App Theme',
                            style: TextStyle(
                              fontSize: FontSizeToken.lg,
                              height: 1,
                              color: context.colors.text,
                              fontWeight: .w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      _ThemeSegmentedControl(currentMode: themeMode),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            _sectionTitle(context, 'Account'),
            const SizedBox(height: Spacing.sm),
            PreferenceCard(
              children: [
                PreferenceTile(
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
                PreferenceTile(
                  icon: LucideIcons.receiptText,
                  title: 'Transaction History',
                  onTap: () {
                    context.pushNamed(AppRoute.transactionHistory.name);
                  },
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            _sectionTitle(context, 'Notifications'),
            const SizedBox(height: Spacing.sm),
            PreferenceCard(
              children: [
                PreferenceTile(
                  icon: LucideIcons.bellRing,
                  title: 'Notification Settings',
                  onTap: () {
                    context.pushNamed(AppRoute.notificationSettings.name);
                  },
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            _sectionTitle(context, 'Security'),
            const SizedBox(height: Spacing.sm),
            PreferenceCard(
              children: [
                PreferenceTile(
                  icon: LucideIcons.lockKeyhole,
                  title: 'Change Password',
                  onTap: () {
                    context.pushNamed(AppRoute.changePassword.name);
                  },
                ),
                PreferenceTile(
                  icon: LucideIcons.smartphone,
                  title: 'Manage Devices',
                  onTap: () {
                    context.pushNamed(AppRoute.manageDevices.name);
                  },
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            _sectionTitle(context, 'Data'),
            const SizedBox(height: Spacing.sm),
            PreferenceCard(
              children: [
                PreferenceTile(
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
    return Padding(
      padding: const EdgeInsets.only(left: Spacing.xs),
      child: Text(
        title,
        style: TextStyle(
          fontSize: FontSizeToken.base,
          fontWeight: .w600,
          color: context.colors.text,
        ),
      ),
    );
  }
}

class PreferenceCard extends StatelessWidget {
  final List<Widget> children;

  const PreferenceCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: .start,
        children: List.generate(children.length, (i) {
          return Column(
            children: [
              if (i > 0) Divider(height: 1, color: context.colors.borderStrong),
              children[i],
            ],
          );
        }),
      ),
    );
  }
}

class PreferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  const PreferenceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, trailing != null ? 8 : 12, 16),
        child: Row(
          spacing: 12,
          children: [
            Icon(
              icon,
              color: isDark ? context.colors.textMuted : context.colors.primary,
              size: 18,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: FontSizeToken.lg,
                  height: 1,
                  color: context.colors.text,
                  fontWeight: .w500,
                ),
              ),
            ),
            ?trailing,
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: context.colors.textSubtle,
            ),
          ],
        ),
      ),
    );
  }
}

/// Same pill design as [SectionTabBar] (the Academic / Personal / Address
/// tabs): a rounded track with a raised white pill under the selected option.
class _ThemeSegmentedControl extends ConsumerWidget {
  final ThemeMode currentMode;

  const _ThemeSegmentedControl({required this.currentMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    final segments = [
      (icon: LucideIcons.sun, label: 'Light', mode: ThemeMode.light),
      (icon: LucideIcons.moon, label: 'Dark', mode: ThemeMode.dark),
      (icon: LucideIcons.monitor, label: 'System', mode: ThemeMode.system),
    ];

    return Container(
      height: 40,
      padding: const EdgeInsets.all(Spacing.xs),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(RadiusToken.md),
      ),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: currentMode == segment.mode
                    ? null
                    : () => ref
                          .read(themeProvider.notifier)
                          .setTheme(segment.mode),
                child: _segment(
                  colors,
                  segment.icon,
                  segment.label,
                  currentMode == segment.mode,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _segment(
    AppColors colors,
    IconData icon,
    String label,
    bool selected,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusToken.sm),
        color: selected ? colors.surface : Colors.transparent,
        boxShadow: selected
            ? [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : const [],
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: 6,
        children: [
          Icon(
            icon,
            size: 14,
            color: selected ? colors.text : colors.textMuted,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizeToken.md,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: selected ? colors.text : colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
