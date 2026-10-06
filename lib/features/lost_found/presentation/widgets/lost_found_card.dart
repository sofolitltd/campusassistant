import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '/core/network/api_endpoints.dart';
import '../../data/models/lost_found_item.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class LostFoundCard extends StatelessWidget {
  final LostFoundItem item;
  final VoidCallback onTap;

  const LostFoundCard({super.key, required this.item, required this.onTap});

  Color _statusColor(BuildContext context) {
    switch (item.status) {
      case LostFoundStatus.open:
        return context.colors.info;
      case LostFoundStatus.claimed:
        return context.colors.warning;
      case LostFoundStatus.resolved:
        return context.colors.success;
      case LostFoundStatus.removed:
        return context.colors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: item.imageUrls.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: ApiEndpoints.resolveImageUrl(
                        item.imageUrls.first,
                      ),
                      fit: .cover,
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    )
                  : Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        item.type == LostFoundType.lost
                            ? Icons.search_off
                            : Icons.check_circle_outline,
                        size: 36,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: item.type == LostFoundType.lost
                              ? context.colors.warning
                              : context.colors.primary,
                          borderRadius: BorderRadius.circular(RadiusToken.xs),
                        ),
                        child: Text(
                          item.type == LostFoundType.lost ? 'LOST' : 'FOUND',
                          style: TextStyle(
                            color: context.colors.onPrimary,
                            fontSize: FontSizeToken.xxs,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _statusColor(context),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  if (item.location.isNotEmpty) ...[
                    const SizedBox(height: Spacing.xxs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: Spacing.xxs),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    timeago.format(item.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: FontSizeToken.xxs,
                    ),
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
