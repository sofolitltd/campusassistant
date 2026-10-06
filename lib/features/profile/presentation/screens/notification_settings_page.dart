import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '../providers/notification_preferences_provider.dart';
import '../widgets/notification_category_meta.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  bool _pushDenied = false;

  @override
  void initState() {
    super.initState();
    _checkPushPermission();
  }

  Future<void> _checkPushPermission() async {
    // None of the per-category toggles below matter if push permission is
    // off at the OS level — surfacing that here (where a user is already
    // thinking about notification preferences) instead of failing silently
    // is the difference between a real setting and a support ticket.
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (!mounted) return;
    setState(() {
      _pushDenied = settings.authorizationStatus == AuthorizationStatus.denied;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(notificationPreferencesProvider);

    return CustomHeaderLayout(
      title: 'Notification Settings',
      showSearchBar: false,
      body: prefsAsync.when(
        data: (prefs) => ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: [
            if (_pushDenied) ...[
              const _PermissionDeniedBanner(),
              const SizedBox(height: Spacing.lg),
            ],
            Text(
              'Choose which notifications you want to receive. Turning one '
              'off stops both the push alert and its entry in your inbox.',
              style: TextStyle(
                color: context.colors.textMuted,
                fontSize: FontSizeToken.md,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            _EmergencyRow(),
            const SizedBox(height: Spacing.md),
            ...notificationCategories.map(
              (meta) => Padding(
                padding: const EdgeInsets.only(bottom: Spacing.md),
                child: _CategoryToggleTile(
                  meta: meta,
                  enabled: prefs[meta.key] ?? true,
                  onChanged: (value) => _onToggle(context, ref, meta, value),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _onToggle(
    BuildContext context,
    WidgetRef ref,
    NotificationCategoryMeta meta,
    bool value,
  ) async {
    try {
      await ref
          .read(notificationPreferencesProvider.notifier)
          .setCategory(meta.key, value);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }
}

class _PermissionDeniedBanner extends StatelessWidget {
  const _PermissionDeniedBanner();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: context.colors.warning.withValues(alpha: isDark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(
          color: context.colors.warning.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Icon(LucideIcons.bellOff, size: 20, color: context.colors.warning),
          const SizedBox(width: Spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Notifications are off',
                  style: TextStyle(
                    fontWeight: .w600,
                    color: context.colors.text,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  'You won\'t receive any push notifications until you '
                  'enable them in system settings — the toggles below won\'t '
                  'help until then.',
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    color: context.colors.textMuted,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                TextButton(
                  onPressed: openAppSettings,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, ControlToken.height),
                  ),
                  child: Text(
                    'Open Settings',
                    style: TextStyle(
                      fontWeight: .bold,
                      color: context.colors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: context.colors.danger.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: context.colors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.siren, size: 20, color: context.colors.danger),
          const SizedBox(width: Spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Emergency & Safety Alerts',
                  style: TextStyle(
                    fontWeight: .w600,
                    color: context.colors.text,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  'Always on — cannot be turned off',
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    color: context.colors.textSubtle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryToggleTile extends StatelessWidget {
  final NotificationCategoryMeta meta;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _CategoryToggleTile({
    required this.meta,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Icon(meta.icon, size: 20, color: context.colors.text),
        title: Text(
          meta.label,
          style: TextStyle(fontWeight: .w600, color: context.colors.text),
        ),
        subtitle: Text(
          meta.description,
          style: TextStyle(
            fontSize: FontSizeToken.sm,
            color: context.colors.textSubtle,
          ),
        ),
        value: enabled,
        activeThumbColor: primaryColor,
        onChanged: onChanged,
      ),
    );
  }
}
