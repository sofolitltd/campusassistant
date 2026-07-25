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
          padding: const EdgeInsets.all(16),
          children: [
            if (_pushDenied) ...[
              const _PermissionDeniedBanner(),
              const SizedBox(height: Spacing.lg),
            ],
            Text(
              'Choose which notifications you want to receive. Turning one '
              'off stops both the push alert and its entry in your inbox.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: Spacing.lg),
            _EmergencyRow(),
            const SizedBox(height: Spacing.md),
            ...notificationCategories.map(
              (meta) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: isDark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.bellOff, size: 20, color: Colors.orange.shade700),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications are off',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You won\'t receive any push notifications until you '
                  'enable them in system settings — the toggles below won\'t '
                  'help until then.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: openAppSettings,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Open Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.siren, size: 20, color: Colors.red.shade600),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency & Safety Alerts',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Always on — cannot be turned off',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).appColors.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Icon(
          meta.icon,
          size: 20,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        title: Text(
          meta.label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          meta.description,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        value: enabled,
        activeThumbColor: primaryColor,
        onChanged: onChanged,
      ),
    );
  }
}
