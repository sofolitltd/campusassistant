import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '/core/theme/app_colors.dart';
import 'home_section.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;
    final colors = context.colors;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                Spacing.xl,
                Spacing.xxl,
                Spacing.xl,
                Spacing.xxl,
              ),
              decoration: BoxDecoration(gradient: homeHeaderGradient(context)),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: colors.onPrimary.withValues(alpha: 0.2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 36,
                        height: 36,
                        fit: .contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    user?.name ?? 'User',
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: FontSizeToken.xl,
                      fontWeight: .bold,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: colors.onPrimary.withValues(alpha: 0.8),
                      fontSize: FontSizeToken.md,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerTile(
                    icon: LucideIcons.user,
                    label: 'Profile',
                    onTap: () => _pushNamed(context, AppRoute.profile.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.bookOpen,
                    label: 'Study',
                    onTap: () => _pushNamed(context, AppRoute.study.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.calendarDays,
                    label: 'Routine',
                    onTap: () => _pushPath(context, AppRoute.routine.path),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.building2,
                    label: 'University',
                    onTap: () => _pushPath(context, AppRoute.university.path),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.library,
                    label: 'Library',
                    onTap: () => _pushPath(context, '/library'),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.helpCircle,
                    label: 'Question Bank',
                    onTap: () => _pushPath(context, '/questions'),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.fileText,
                    label: 'Syllabus',
                    onTap: () => _pushPath(context, '/syllabus'),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.bookmark,
                    label: 'Bookmarks',
                    onTap: () => _pushNamed(context, AppRoute.bookmarks.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.folderDown,
                    label: 'Downloads',
                    onTap: () =>
                        _pushNamed(context, AppRoute.downloadedFiles.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.users,
                    label: 'Contributors',
                    onTap: () =>
                        _pushNamed(context, AppRoute.contributors.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.messageSquare,
                    label: 'Send Feedback',
                    onTap: () => _pushPath(context, AppRoute.feedback.path),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.bellRing,
                    label: 'Notification Settings',
                    onTap: () =>
                        _pushNamed(context, AppRoute.notificationSettings.name),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Some routes are addressed by path, others only by name; passing a route
  // *name* to context.push() treats it as a path and goes nowhere, so the two
  // are kept as separate, explicit helpers.
  void _pushPath(BuildContext context, String path) {
    Navigator.pop(context); // close drawer
    context.push(path);
  }

  void _pushNamed(BuildContext context, String name) {
    Navigator.pop(context); // close drawer
    context.pushNamed(name);
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      leading: Icon(icon, color: colors.primary, size: 20),
      title: Text(
        label,
        style: TextStyle(
          fontSize: FontSizeToken.base,
          fontWeight: .w500,
          color: colors.text,
        ),
      ),
      trailing: Icon(
        LucideIcons.chevronRight,
        size: 16,
        color: colors.textSubtle,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.xl,
        vertical: Spacing.xxs,
      ),
    );
  }
}
