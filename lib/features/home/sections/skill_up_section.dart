import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/error/failures.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/section_card.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/skill/data/models/skill.dart';
import '/features/skill/presentation/providers/skill_provider.dart';
import '/routes/app_route.dart';
import '../widgets/home_section.dart';
import '/core/theme/tokens/app_font_size.dart';

class SkillUpSection extends ConsumerWidget {
  const SkillUpSection({super.key});

  static const double _listHeight = 190;
  static const double _cardWidth = 200;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;
    if (user == null) return const SizedBox.shrink();

    final args = (universityId: user.university, departmentId: user.department);

    return ref
        .watch(skillsListProvider(args))
        .when(
          loading: () => const HomeSectionLoading(height: _listHeight),
          error: (e, _) => HomeSectionError(
            offline: e is NetworkFailure,
            message: e is NetworkFailure
                ? 'No internet connection'
                : 'Unable to load skills',
            onRetry: () => ref.invalidate(skillsListProvider(args)),
          ),
          data: (skills) {
            if (skills.isEmpty) return const SizedBox.shrink();
            return HomeSection(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const HomeSectionHeader('Skill Up'),
                  const SizedBox(height: Spacing.sm),
                  SizedBox(
                    height: _listHeight,
                    child: ListView.separated(
                      scrollDirection: .horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: homeInset,
                      ),
                      itemCount: skills.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: Spacing.md),
                      itemBuilder: (context, i) => SizedBox(
                        width: _cardWidth,
                        child: _SkillCard(skill: skills[i]),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final placeholder = ColoredBox(
      color: colors.surfaceAlt,
      child: Center(
        child: Icon(LucideIcons.sparkles, color: colors.textSubtle),
      ),
    );

    return SectionCard(
      radius: homeCardRadius,
      padding: EdgeInsets.zero,
      onTap: () => context.pushNamed(
        AppRoute.skillDetails.name,
        pathParameters: {'skillId': skill.id},
        extra: skill,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: skill.thumbnailUrl.isEmpty
                ? placeholder
                : CachedNetworkImage(
                    imageUrl: ApiEndpoints.resolveImageUrl(skill.thumbnailUrl),
                    fit: .contain,
                    placeholder: (_, _) => placeholder,
                    errorWidget: (_, _, _) => placeholder,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  skill.title,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontWeight: .w600,
                    fontSize: FontSizeToken.md,
                    height: 1.2,
                    color: colors.text,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Row(
                  children: [
                    Icon(
                      LucideIcons.circlePlay,
                      size: 12,
                      color: colors.textMuted,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      '${skill.videos.length} videos',
                      style: TextStyle(
                        fontSize: FontSizeToken.xs,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
