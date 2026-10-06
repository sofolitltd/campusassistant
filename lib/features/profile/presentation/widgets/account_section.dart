import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/presentation/providers/auth_provider.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: Spacing.lg),
      child: GestureDetector(
        onTap: () => _showLogoutBottomSheet(context, ref),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: Spacing.md),
          decoration: BoxDecoration(
            color: context.colors.danger.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(RadiusToken.lg),
            border: Border.all(color: context.colors.danger),
          ),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Text(
                'LOGOUT',
                style: TextStyle(
                  color: context.colors.danger,
                  fontSize: FontSizeToken.lg,
                  fontWeight: .bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Icon(LucideIcons.logOut, color: context.colors.danger, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxxl),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
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
                // Warning icon circle
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.alertTriangle,
                    color: context.colors.onPrimary,
                    size: 36,
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                const Text(
                  'Are you sure you want to log out?',
                  textAlign: .center,
                  style: TextStyle(
                    fontSize: FontSizeToken.xxl,
                    fontWeight: .bold,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  'You will need to log in again to continue using your account.',
                  textAlign: .center,
                  style: TextStyle(
                    fontSize: FontSizeToken.base,
                    color: context.colors.textMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: Spacing.xxxl),
                // Yes, Log Out button
                SizedBox(
                  width: double.infinity,
                  height: ControlToken.height,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await ref.read(currentUserProvider.notifier).logout();
                        if (context.mounted) {
                          context.go(AppRoute.login.path);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to log out: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.danger,
                      foregroundColor: context.colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(RadiusToken.lg),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Yes, Log Out',
                      style: TextStyle(
                        fontSize: FontSizeToken.lg,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                // Cancel button
                SizedBox(
                  width: double.infinity,
                  height: ControlToken.height,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
        );
      },
    );
  }
}
