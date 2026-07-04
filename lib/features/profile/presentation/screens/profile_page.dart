import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/profile_card.dart';
import 'package:campusassistant/features/auth/presentation/providers/auth_provider.dart';
import 'package:campusassistant/routes/app_route.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';
import 'package:campusassistant/core/theme/tokens/app_spacing.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          userAsync.maybeWhen(
            data: (user) => user == null
                ? const SizedBox.shrink()
                : PopupMenuButton<String>(
                    color: Theme.of(context).cardColor,
                    icon: Icon(LucideIcons.settings, size: 20),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          context.pushNamed(
                            AppRoute.editProfile.name,
                            queryParameters: {'uid': user.id},
                          );
                          break;
                        case 'password':
                          context.pushNamed(AppRoute.changePassword.name);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        height: 40,
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(LucideIcons.userRoundPen, size: 18),
                            const SizedBox(width: 10),
                            Text('Edit Profile'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        height: 40,
                        value: 'password',
                        child: Row(
                          children: [
                            Icon(LucideIcons.lockKeyhole, size: 18),
                            const SizedBox(width: 10),
                            Text('Change Password'),
                          ],
                        ),
                      ),
                    ],
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 700),
          alignment: Alignment.center,
          child: userAsync.when(
            data: (user) => user == null
                ? const Center(child: Text('User not found'))
                : ProfileCard(user: user),
            loading: () => const Skeletonizer(
              enabled: true,
              child: _ProfileSkeleton(),
            ),
            error: (error, _) =>
                Center(child: Text('Error: ${error.toString()}')),
          ),
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? theme.cardColor : Colors.white;
    final borderClr = isDark ? Colors.white10 : Colors.grey.shade200;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Header skeleton
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(RadiusToken.md),
              border: Border.all(color: borderClr),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 90, width: 90,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(RadiusToken.md),
                    border: Border.all(color: borderClr),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Full Name', style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Plan', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          // Section: Contact
          _sectionSkeleton(theme, isDark),
          const SizedBox(height: Spacing.lg),
          // Section: Account
          _sectionSkeleton(theme, isDark),
          const SizedBox(height: 8),
          // Section: Theme
          _sectionSkeleton(theme, isDark),
          const SizedBox(height: Spacing.lg),
          // Section: Essentials
          _sectionSkeleton(theme, isDark),
        ],
      ),
    );
  }

  Widget _sectionSkeleton(ThemeData theme, bool isDark) {
    final cardBg = isDark ? theme.cardColor : Colors.white;
    final borderClr = isDark ? Colors.white10 : Colors.grey.shade200;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: borderClr),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40, width: 40,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(RadiusToken.md),
                  border: Border.all(color: borderClr),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Section Title',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text('Subtitle', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _rowItem(theme, isDark),
          const Divider(),
          _rowItem(theme, isDark),
        ],
      ),
    );
  }

  Widget _rowItem(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Container(
          height: 20, width: 20,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text('Item label', style: theme.textTheme.bodySmall)),
      ],
    );
  }
}
