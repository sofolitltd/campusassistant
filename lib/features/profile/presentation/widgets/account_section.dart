import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:campusassistant/core/theme/app_colors.dart';
import 'package:campusassistant/features/auth/presentation/providers/auth_provider.dart';
import 'package:campusassistant/routes/app_route.dart';
import 'section_header.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).appColors;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          SectionHeader(
            title: 'Account',
            subtitle: 'Manage your account',
            icon: LucideIcons.shield,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).cardColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.logoutButtonBg,
                  foregroundColor: cs.error,
                  elevation: 0,
                ),
                onPressed: () => _logOutDialog(context, ref),
                child: Text('Log out'.toUpperCase()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _logOutDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure to log out?'),
          actions: [
            OutlinedButton(
              onPressed: context.pop,
              child: Text('Cancel'.toUpperCase()),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              onPressed: () async {
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
              style:
                  const ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text('Log out'.toUpperCase()),
            ),
          ],
        );
      },
    );
  }
}
