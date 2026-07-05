import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_radius.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;
    final primaryRed = const Color(0xFFD32F2F);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: const BoxDecoration(color: Color(0xFFD32F2F)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name?.toUpperCase() ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
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
                    onTap: () => _navigate(context, AppRoute.profile.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.bookOpen,
                    label: 'Study',
                    onTap: () => _navigate(context, AppRoute.study.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.calendarDays,
                    label: 'Routine',
                    onTap: () => _navigate(context, AppRoute.routine.path),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.building2,
                    label: 'University',
                    onTap: () => _navigate(context, AppRoute.university.path),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.library,
                    label: 'Library',
                    onTap: () => _navigate(context, '/library'),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.helpCircle,
                    label: 'Question Bank',
                    onTap: () => _navigate(context, '/questions'),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.fileText,
                    label: 'Syllabus',
                    onTap: () => _navigate(context, '/syllabus'),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.bookmark,
                    label: 'Bookmarks',
                    onTap: () => _navigate(context, AppRoute.bookmarks.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.folderDown,
                    label: 'Downloads',
                    onTap: () => _navigate(context, AppRoute.downloadedFiles.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.users,
                    label: 'Contributors',
                    onTap: () => _navigate(context, AppRoute.contributors.name),
                  ),
                  _DrawerTile(
                    icon: LucideIcons.settings,
                    label: 'Settings',
                    onTap: () => _navigate(context, AppRoute.profile.path),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context); // close drawer
    context.push(route);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(icon, color: Color(0xFFD32F2F), size: 20),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white70 : Colors.grey.shade800,
        ),
      ),
      trailing: Icon(
        LucideIcons.chevronRight,
        size: 16,
        color: isDark ? Colors.white30 : Colors.grey.shade400,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}
