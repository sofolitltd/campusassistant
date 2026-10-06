import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../domain/entities/resource.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';

/// Compact tile for a `type: 'video'` [Resource] — video lectures embed a
/// YouTube URL in `fileUrl` rather than a PDF, so they can't use
/// [ResourceCard] (which always opens `fileUrl` in the PDF viewer). Mirrors
/// the video row UI/navigation from `course_videos_page.dart`, minus the
/// course-context-only edit/delete controls that page adds.
class ResourceVideoTile extends StatelessWidget {
  final Resource resource;
  const ResourceVideoTile({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final videoId =
        YoutubePlayerController.convertUrlToId(resource.fileUrl) ?? '';
    final thumb = YoutubePlayerController.getThumbnail(videoId: videoId);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.sm),
        onTap: videoId.isEmpty
            ? null
            : () => context.push(
                Uri(
                  path: AppRoute.youtubePlayer.toPath({'videoId': videoId}),
                  queryParameters: {'title': resource.title},
                ).toString(),
              ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 90,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(RadiusToken.md),
                      bottomLeft: Radius.circular(RadiusToken.md),
                    ),
                    child: Image.network(
                      thumb,
                      fit: .cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark
                            ? theme.colorScheme.surface.withValues(alpha: 0.5)
                            : context.colors.surfaceAlt,
                        child: Icon(
                          LucideIcons.video,
                          color: context.colors.textSubtle,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(Spacing.xs),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.play,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: 90,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      resource.title,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: .bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      resource.description,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
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
