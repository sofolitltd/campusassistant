import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_radius.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class ShortcutSection extends ConsumerWidget {
  const ShortcutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Skeletonizer(
        enabled: true,
        child: _ShortcutSkeleton(),
      ),
      error: (e, _) =>
          SizedBox(height: 200, child: Center(child: Text("Error: $e"))),
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final items = _shortcutList;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(RadiusToken.md),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.md, Spacing.md, Spacing.md, Spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: Spacing.xs, bottom: Spacing.sm),
                    child: Text(
                      'Quick Access',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        _GridItem(shortcut: items[index]),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GridItem extends StatelessWidget {
  final _ShortcutItem shortcut;

  const _GridItem({required this.shortcut});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push(shortcut.route),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.10)
                : Colors.grey.shade200,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    shortcut.color.withValues(alpha: 0.80),
                    shortcut.color.withValues(alpha: 0.45),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(shortcut.icon, size: 16, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              shortcut.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: isDark ? Colors.white60 : Colors.grey.shade700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutSkeleton extends StatelessWidget {
  const _ShortcutSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.md),
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
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.sm),
                child: Container(
                  width: 80,
                  height: 13,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 4,
                ),
                itemCount: 6,
                itemBuilder: (_, _) => Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(RadiusToken.md),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ─── Shortcut Model ─────────────────────────────────────────────────────────────

class _ShortcutItem {
  final String name;
  final String route;
  final IconData icon;
  final Color color;

  const _ShortcutItem({
    required this.name,
    required this.route,
    required this.icon,
    required this.color,
  });
}

final List<_ShortcutItem> _shortcutList = [
  _ShortcutItem(
    name: 'Routine',
    route: '/routine',
    icon: LucideIcons.calendarDays,
    color: const Color(0xFF3B82F6),
  ),
  _ShortcutItem(
    name: 'Alumni',
    route: '/alumni',
    icon: LucideIcons.graduationCap,
    color: const Color(0xFF8B5CF6),
  ),
  _ShortcutItem(
    name: 'Emergency',
    route: '/emergency',
    icon: LucideIcons.phoneCall,
    color: const Color(0xFFEF4444),
  ),
  _ShortcutItem(
    name: 'Transport',
    route: '/transport',
    icon: LucideIcons.bus,
    color: const Color(0xFFF59E0B),
  ),
  _ShortcutItem(
    name: 'Clubs',
    route: '/club',
    icon: LucideIcons.heart,
    color: const Color(0xFFEC4899),
  ),
  _ShortcutItem(
    name: 'Blood Bank',
    route: '/blood-bank',
    icon: LucideIcons.droplets,
    color: const Color(0xFFDC2626),
  ),
];
