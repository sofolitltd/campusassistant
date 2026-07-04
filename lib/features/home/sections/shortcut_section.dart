import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import '../../auth/domain/entities/user.dart' as user_entity;

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
          SizedBox(height: 110, child: Center(child: Text("Error: $e"))),
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        return SizedBox(
          height: 105,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width:
            12),
            shrinkWrap: true,
            itemCount: shortcutList.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            itemBuilder: (context, index) => MoreCard(index: index, user: user),
          ),
        );
      },
    );
  }
}

class _ShortcutSkeleton extends StatelessWidget {
  const _ShortcutSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 105,
      child: ListView.separated(
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
        itemBuilder: (_, _) {
          return Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isDark ? theme.cardColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.grey.shade50,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.fromLTRB(8, 0, 4, 4),
                  child: Text('Loading'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MoreCard extends StatelessWidget {
  final user_entity.User user;
  final int index;

  const MoreCard({super.key, required this.index, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(shortcutList[index].route);
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.all(6),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.shade50,
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(shortcutList[index].imageUrl),
              ),
            ),
            Container(
              width: 100,
              padding: const EdgeInsets.fromLTRB(8, 0, 4, 4),
              child: Text(
                shortcutList[index].name,
                textAlign: TextAlign.start,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(fontSize: 11, height: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<MoreModel> shortcutList = [
  MoreModel(
    name: 'Class\nRoutine',
    route: '/routine',
    imageUrl: 'assets/images/shortcut/routine.png',
  ),
  MoreModel(
    name: 'Alumni\nNetwork',
    route: '/alumni',
    imageUrl: 'assets/images/shortcut/alumni.png',
  ),
  MoreModel(
    name: 'Emergency\nContact',
    route: '/emergency',
    imageUrl: 'assets/images/shortcut/emergency.png',
  ),
  MoreModel(
    name: 'Transport\nService',
    route: '/transport',
    imageUrl: 'assets/images/shortcut/transports.png',
  ),
  MoreModel(
    name: 'Club &\nOrganization ',
    route: '/club',
    imageUrl: 'assets/images/shortcut/clubs.png',
  ),
  MoreModel(
    name: 'Blood\nBank',
    route: '/blood-bank',
    imageUrl: 'assets/images/shortcut/blood-bank.png',
  ),
];

class MoreModel {
  final String name;
  final String route;
  final String imageUrl;

  MoreModel({required this.name, required this.route, required this.imageUrl});
}
