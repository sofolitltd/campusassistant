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
    final c = context.colors;
    final isLost = item.type == LostFoundType.lost;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: c.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                child: SizedBox(
                  width: 92,
                  height: 92,
                  child: item.imageUrls.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: ApiEndpoints.resolveImageUrl(
                            item.imageUrls.first,
                          ),
                          fit: .cover,
                          errorWidget: (context, url, error) => Container(
                            color: c.surfaceAlt,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: c.borderStrong,
                            ),
                          ),
                        )
                      : Container(
                          color: c.surfaceAlt,
                          child: Icon(
                            isLost
                                ? Icons.search_off
                                : Icons.check_circle_outline,
                            size: 32,
                            color: c.borderStrong,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
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
                            color: isLost ? c.warning : c.primary,
                            borderRadius: BorderRadius.circular(RadiusToken.xs),
                          ),
                          child: Text(
                            isLost ? 'LOST' : 'FOUND',
                            style: TextStyle(
                              color: c.onPrimary,
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
                      style: const TextStyle(
                        fontWeight: .w700,
                        fontSize: FontSizeToken.base,
                      ),
                    ),
                    if (item.location.isNotEmpty) ...[
                      const SizedBox(height: Spacing.xs),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: c.textMuted,
                          ),
                          const SizedBox(width: Spacing.xxs),
                          Expanded(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: TextStyle(
                                color: c.textMuted,
                                fontSize: FontSizeToken.sm,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: Spacing.xs),
                    Text(
                      timeago.format(item.createdAt),
                      style: TextStyle(
                        color: c.textSubtle,
                        fontSize: FontSizeToken.xs,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: Spacing.xs),
                child: Icon(Icons.chevron_right, size: 18, color: c.textSubtle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
