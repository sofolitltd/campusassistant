import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/skill/data/models/skill.dart';
import '/features/skill/presentation/providers/skill_provider.dart';
import '/routes/app_route.dart';

class SkillUpSection extends ConsumerWidget {
  const SkillUpSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;
    if (user == null) return const SizedBox.shrink();

    final skillsAsync = ref.watch(
      skillsListProvider((
        universityId: user.university,
        departmentId: user.department,
      )),
    );

    return skillsAsync.when(
      data: (skills) {
        if (skills.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Skill Up',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: skills.length,
                itemBuilder: (context, i) => _SkillCard(skill: skills[i]),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 190,
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final Skill skill;

  const _SkillCard({required this.skill});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoute.skillDetails.name,
        pathParameters: {'skillId': skill.id},
        extra: skill,
      ),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
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
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(RadiusToken.lg),
              ),
              child: SizedBox(
                height: 90,
                width: double.infinity,
                child: skill.thumbnailUrl.isNotEmpty
                    ? Image.network(
                        skill.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: Colors.grey.shade100,
                              child: Icon(
                                LucideIcons.sparkles,
                                color: Colors.grey.shade400,
                              ),
                            ),
                      )
                    : Container(
                        color: Colors.grey.shade100,
                        child: Icon(
                          LucideIcons.sparkles,
                          color: Colors.grey.shade400,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.playCircle,
                        size: 12,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${skill.videos.length} videos',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? Colors.white54
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
