import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '../../data/models/skill.dart';
import '../../data/models/skill_video.dart';
import '../providers/skill_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class SkillDetailsPage extends ConsumerWidget {
  final Skill? skill;
  final String? skillId;

  const SkillDetailsPage({super.key, required this.skill, this.skillId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // `skill` is passed via go_router `extra`, but that is dropped when the
    // router rebuilds (e.g. returning from the video player), so fall back to
    // resolving the skill by its id from the already-loaded skills list.
    final skill = this.skill;
    if (skill != null) return _buildContent(context, skill);

    if (skillId == null) return _notFound(context);

    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;
    if (user == null) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
    }

    final skillsAsync = ref.watch(
      skillsListProvider((
        universityId: user.university,
        departmentId: user.department,
      )),
    );

    return skillsAsync.when(
      data: (skills) {
        final match = skills.where((s) => s.id == skillId).firstOrNull;
        return match != null
            ? _buildContent(context, match)
            : _notFound(context);
      },
      loading: () =>
          const Scaffold(body: Center(child: CupertinoActivityIndicator())),
      error: (_, _) => _notFound(context),
    );
  }

  Widget _notFound(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Up')),
      body: const Center(child: Text('Skill not found.')),
    );
  }

  Widget _buildContent(BuildContext context, Skill skill) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                // White on purpose: sits over the skill's cover image in both themes.
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: skill.thumbnailUrl.isNotEmpty
                      ? Image.network(
                          ApiEndpoints.resolveImageUrl(skill.thumbnailUrl),
                          fit: .cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: context.colors.borderStrong),
                        )
                      : Container(color: context.colors.borderStrong),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        skill.title,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(fontWeight: .bold),
                      ),
                      if (skill.description.isNotEmpty) ...[
                        const SizedBox(height: Spacing.sm),
                        Text(
                          skill.description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: context.colors.textMuted,
                                height: 1.4,
                              ),
                        ),
                      ],
                      const SizedBox(height: Spacing.sm),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.playCircle,
                            size: 14,
                            color: context.colors.textSubtle,
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            '${skill.videos.length} videos',
                            style: TextStyle(
                              fontSize: FontSizeToken.sm,
                              color: context.colors.textSubtle,
                              fontWeight: .w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (skill.videos.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Spacing.xxxxl),
                    child: Center(child: Text('No videos in this skill yet.')),
                  ),
                )
              else
                SliverList.separated(
                  itemCount: skill.videos.length,
                  separatorBuilder: (context, i) =>
                      const SizedBox(height: Spacing.md),
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    child: _SkillVideoRow(
                      video: skill.videos[i],
                      number: i + 1,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: Spacing.xxl)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillVideoRow extends StatelessWidget {
  final SkillVideo video;
  final int number;

  const _SkillVideoRow({required this.video, required this.number});

  @override
  Widget build(BuildContext context) {
    final videoId =
        YoutubePlayerController.convertUrlToId(video.youtubeUrl) ?? '';
    final thumb = video.thumbnailUrl.isNotEmpty
        ? video.thumbnailUrl
        : (videoId.isNotEmpty
              ? YoutubePlayerController.getThumbnail(videoId: videoId)
              : '');

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.surfaceAlt),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: videoId.isEmpty
            ? null
            : () => context.push(
                Uri(
                  path: AppRoute.youtubePlayer.toPath({'videoId': videoId}),
                  queryParameters: {'title': video.title},
                ).toString(),
              ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: 110,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(RadiusToken.md),
                      bottomLeft: Radius.circular(RadiusToken.md),
                    ),
                    child: thumb.isNotEmpty
                        ? Image.network(
                            ApiEndpoints.resolveImageUrl(thumb),
                            fit: .cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: context.colors.surfaceAlt,
                                  child: Icon(
                                    LucideIcons.video,
                                    color: context.colors.textSubtle,
                                  ),
                                ),
                          )
                        : Container(
                            color: context.colors.surfaceAlt,
                            child: Icon(
                              LucideIcons.video,
                              color: context.colors.textSubtle,
                            ),
                          ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(Spacing.xs),
                  decoration: BoxDecoration(
                    color: context.colors.textMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.play,
                    color: context.colors.onPrimary,
                    size: 16,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      '$number. ${video.title}',
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: const TextStyle(fontWeight: .bold, height: 1.2),
                    ),
                    if (video.duration.isNotEmpty) ...[
                      const SizedBox(height: Spacing.xs),
                      Text(
                        video.duration,
                        style: TextStyle(
                          fontSize: FontSizeToken.sm,
                          color: context.colors.textSubtle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
