import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/routes/app_route.dart';
import '/services/device_repository.dart';
import '../providers/manage_devices_provider.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class ManageDevicesPage extends ConsumerWidget {
  const ManageDevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(manageDevicesProvider);

    return CustomHeaderLayout(
      title: 'Manage Devices',
      showSearchBar: false,
      body: devicesAsync.when(
        data: (devices) => RefreshIndicator(
          onRefresh: () => ref.read(manageDevicesProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(Spacing.lg),
            children: [
              Text(
                'Devices logged into your account. Remove one you don\'t '
                'recognize, or sign out everywhere at once.',
                style: TextStyle(
                  color: context.colors.textMuted,
                  fontSize: FontSizeToken.md,
                ),
              ),
              const SizedBox(height: Spacing.lg),
              if (devices.isEmpty)
                _buildEmptyState(context)
              else
                ...devices.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.md),
                    child: _DeviceTile(device: d),
                  ),
                ),
              const SizedBox(height: Spacing.lg),
              OutlinedButton.icon(
                onPressed: devices.length <= 1
                    ? null
                    : () => _confirmLogoutOthers(context, ref),
                icon: const Icon(LucideIcons.logOut, size: 18),
                label: const Text('Log Out of Other Devices'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(ControlToken.height),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RadiusToken.lg),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),
              ElevatedButton.icon(
                onPressed: () => _confirmLogoutAll(context, ref),
                icon: const Icon(LucideIcons.shieldAlert, size: 18),
                label: const Text('Log Out of All Devices'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.danger,
                  foregroundColor: context.colors.onPrimary,
                  minimumSize: const Size.fromHeight(ControlToken.height),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RadiusToken.lg),
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxxxl),
      child: Column(
        children: [
          Icon(
            LucideIcons.smartphone,
            size: 56,
            color: context.colors.borderStrong,
          ),
          const SizedBox(height: Spacing.md),
          Text(
            'No devices registered',
            style: TextStyle(
              color: context.colors.textMuted,
              fontWeight: .w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogoutOthers(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out of other devices?'),
        content: const Text(
          'Every other device signed into your account will be logged out. '
          'This device stays signed in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out others'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(manageDevicesProvider.notifier).logoutOthers();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out of other devices')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _confirmLogoutAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxxl),
        ),
      ),
      builder: (ctx) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.xxl,
            Spacing.xxxl,
            Spacing.xxl,
            36,
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.shieldAlert,
                  color: context.colors.onPrimary,
                  size: 32,
                ),
              ),
              const SizedBox(height: Spacing.xl),
              const Text(
                'Log out of all devices?',
                textAlign: .center,
                style: TextStyle(
                  fontSize: FontSizeToken.xxl,
                  fontWeight: .bold,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                'This signs you out everywhere, including this device. '
                'You\'ll need to log in again.',
                textAlign: .center,
                style: TextStyle(
                  fontSize: FontSizeToken.base,
                  color: context.colors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: Spacing.xxxl),
              SizedBox(
                width: double.infinity,
                height: ControlToken.height,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.danger,
                    foregroundColor: context.colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(RadiusToken.lg),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Yes, Log Out Everywhere',
                    style: TextStyle(
                      fontSize: FontSizeToken.lg,
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),
              SizedBox(
                width: double.infinity,
                height: ControlToken.height,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: context.colors.borderStrong),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(RadiusToken.lg),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: FontSizeToken.lg,
                      fontWeight: .w500,
                      color: context.colors.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(manageDevicesProvider.notifier).logoutAll();
      await ref.read(currentUserProvider.notifier).logout();
      if (context.mounted) {
        context.go(AppRoute.login.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to log out: $e')));
      }
    }
  }
}

class _DeviceTile extends ConsumerWidget {
  final Device device;

  const _DeviceTile({required this.device});

  IconData get _platformIcon {
    return switch (device.platform) {
      'ios' || 'android' => LucideIcons.smartphone,
      'web' => LucideIcons.monitor,
      _ => LucideIcons.smartphone,
    };
  }

  String get _platformLabel {
    return switch (device.platform) {
      'ios' => 'iOS',
      'android' => 'Android',
      'web' => 'Web',
      _ => device.platform,
    };
  }

  String _lastSeenLabel() {
    final diff = DateTime.now().difference(device.lastSeenAt);
    if (diff.inMinutes < 1) return 'Active just now';
    if (diff.inMinutes < 60) return 'Active ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Active ${diff.inHours}h ago';
    return 'Active ${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(
          color: device.isCurrent
              ? context.colors.primary.withValues(alpha: 0.5)
              : (context.colors.border),
        ),
      ),
      child: Row(
        children: [
          Icon(_platformIcon, size: 22, color: context.colors.primary),
          const SizedBox(width: Spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Text(
                      _platformLabel,
                      style: const TextStyle(fontWeight: .w600),
                    ),
                    if (device.isCurrent) ...[
                      const SizedBox(width: Spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).appColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(RadiusToken.xxl),
                        ),
                        child: Text(
                          'This device',
                          style: TextStyle(
                            fontSize: FontSizeToken.xs,
                            fontWeight: .w600,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  _lastSeenLabel(),
                  style: TextStyle(
                    fontSize: FontSizeToken.sm,
                    color: context.colors.textSubtle,
                  ),
                ),
              ],
            ),
          ),
          if (!device.isCurrent)
            IconButton(
              icon: const Icon(LucideIcons.trash2, size: 18),
              color: context.colors.danger,
              onPressed: () => _confirmRemove(context, ref),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmRemove(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove this device?'),
        content: Text(
          'This $_platformLabel device will stop receiving notifications. '
          'It will need to log in again to be re-added.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(manageDevicesProvider.notifier).removeDevice(device.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to remove device: $e')));
      }
    }
  }
}
