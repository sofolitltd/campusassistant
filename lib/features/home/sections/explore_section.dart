import 'package:campusassistant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import '../../university/presentation/providers/university_provider.dart';
import '../../department/presentation/providers/department_provider.dart';
import '../../batch/presentation/providers/batch_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_radius.dart';

class ExploreSection extends ConsumerWidget {
  const ExploreSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Skeletonizer(
        enabled: true,
        child: _ExploreSkeleton(),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        final universityName = user.universityId != null
            ? ref.watch(universityNameProvider(user.universityId!))
            : 'University';

        final departmentName = user.departmentId != null &&
                user.universityId != null
            ? ref.watch(
                departmentNameProvider('${user.universityId}|${user.departmentId}'),
              )
            : 'Department';

        if (user.departmentId != null) {
          final bId = user.batch?.trim();
          if (bId != null && bId != '' && bId != '0') {
            ref.watch(
              batchNameProvider(
                departmentId: user.departmentId!,
                id: bId,
              ),
            );
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ExploreCard(
                label: 'Your University',
                subtitle: universityName,
                icon: LucideIcons.building2,
                color: const Color(0xFF6366F1),
                onTap: () => context.push(AppRoute.university.path),
              ),
              const SizedBox(height: Spacing.md),
              _ExploreCard(
                label: 'Department',
                subtitle: departmentName,
                icon: LucideIcons.layoutGrid,
                color: const Color(0xFF06B6D4),
                onTap: () => context.push(AppRoute.department.path),
              ),
              const SizedBox(height: Spacing.md),
              _ExploreCard(
                label: 'Community',
                subtitle: 'Connect, share & discuss with peers',
                icon: LucideIcons.messageSquare,
                color: const Color(0xFFF97316),
                onTap: () => context.pushNamed(AppRoute.community.name),
                showChevron: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool showChevron;

  const _ExploreCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.xl),
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
          padding: const EdgeInsets.all(Spacing.lg),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isDark
                      ? color.withValues(alpha: 0.8)
                      : color,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.5)
                                : Colors.grey.shade600,
                            letterSpacing: 0.3,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            height: 1.3,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (showChevron)
                Padding(
                  padding: const EdgeInsets.only(left: Spacing.xs),
                  child: Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.grey.shade400,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreSkeleton extends StatelessWidget {
  const _ExploreSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SkeletonCard(isDark: isDark, theme: theme),
          const SizedBox(height: Spacing.md),
          _SkeletonCard(isDark: isDark, theme: theme),
          const SizedBox(height: Spacing.md),
          _SkeletonCard(isDark: isDark, theme: theme, showChevron: true),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;
  final bool showChevron;

  const _SkeletonCard({
    required this.isDark,
    required this.theme,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.xl),
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
        padding: const EdgeInsets.all(Spacing.lg),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(RadiusToken.sm),
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 11,
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 160,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron)
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
