import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../domain/entities/resource.dart';

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
    final videoId = YoutubePlayer.convertUrlToId(resource.fileUrl) ?? '';
    final thumb = YoutubePlayer.getThumbnail(videoId: videoId);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.blueGrey.shade50,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: Image.network(
                      thumb,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark
                            ? theme.colorScheme.surface.withValues(alpha: 0.5)
                            : Colors.grey.shade100,
                        child: Icon(
                          LucideIcons.video,
                          color: isDark ? Colors.white38 : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
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
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resource.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: isDark ? Colors.white70 : Colors.grey,
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
