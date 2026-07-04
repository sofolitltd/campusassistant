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

        // Student subtitle logic
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🏛️ University Card
                    Expanded(
                      child: _ActionCard(
                        title: 'University',
                        subtitle: universityName,
                        icon: LucideIcons.building,
                        onTap: () => context.push(AppRoute.university.path),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 🏢 Department Card
                    Expanded(
                      child: _ActionCard(
                        title: 'Department',
                        subtitle: departmentName,
                        icon: LucideIcons.layoutGrid,
                        onTap: () => context.push(AppRoute.department.path),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // 💬 Community Card
              _CommunityCard(
                onTap: () => context.pushNamed(AppRoute.community.name),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.blueGrey.shade700,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle, // The actual name (e.g. 'University of Dhaka')
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
          ],
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final VoidCallback onTap;

  const _CommunityCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.teal.shade800, Colors.teal.shade600]
                : [Colors.teal.shade50, Colors.teal.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.teal.shade400.withValues(alpha: 0.3) : Colors.teal.shade200,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                LucideIcons.messageSquare,
                color: isDark ? Colors.white : Colors.teal.shade700,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Community',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? Colors.white : Colors.teal.shade900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Connect, share & discuss with peers',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: isDark ? Colors.white54 : Colors.teal.shade400,
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _ExploreCard()),
              const SizedBox(width: 12),
              Expanded(child: _ExploreCard()),
            ],
          ),
          const SizedBox(height: 12),
          _CommunitySkeleton(isDark: isDark, theme: theme),
        ],
      ),
    );
  }
}

class _CommunitySkeleton extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _CommunitySkeleton({required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: const Row(
        children: [
          SizedBox(width: 38, height: 38),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Community'),
                SizedBox(height: 2),
                Text('Subtitle text', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 20, height: 20),
          SizedBox(height: 12),
          Text('Loading'),
        ],
      ),
    );
  }
}
