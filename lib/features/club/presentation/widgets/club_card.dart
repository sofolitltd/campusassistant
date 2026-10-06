import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/club/domain/entities/club.dart';
import '/routes/app_route.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// A single club — public, drop-in card. Tap navigates to the club details
/// route (built in, no external onTap wiring needed). Used by both
/// `ClubsList` (club_page.dart) and the global search results page.
class ClubCard extends StatelessWidget {
  final Club club;

  const ClubCard({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoute.clubDetails.name,
          pathParameters: {'clubId': club.id},
          extra: club,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.border, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RadiusToken.md),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              club.bannerUrl != null && club.bannerUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: ApiEndpoints.resolveImageUrl(club.bannerUrl),
                      height: 120,
                      fit: .cover,
                      errorWidget: (context, url, error) => Container(
                        height: 120,
                        color: primaryColor.withValues(alpha: 0.08),
                        child: Icon(
                          LucideIcons.image,
                          color: primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                    )
                  : Container(
                      height: 120,
                      color: primaryColor.withValues(alpha: 0.08),
                      child: Icon(
                        LucideIcons.image,
                        color: primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  Spacing.md,
                  Spacing.lg,
                  Spacing.lg,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceAlt,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colors.border,
                          width: 2,
                        ),
                      ),
                      child: club.logoUrl != null && club.logoUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                RadiusToken.xxxl,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: ApiEndpoints.resolveImageUrl(
                                  club.logoUrl,
                                ),
                                fit: .cover,
                                errorWidget: (context, url, error) => Icon(
                                  LucideIcons.users,
                                  color: context.colors.textSubtle,
                                  size: 22,
                                ),
                              ),
                            )
                          : Icon(
                              LucideIcons.users,
                              color: context.colors.textSubtle,
                              size: 22,
                            ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  club.name,
                                  style: TextStyle(
                                    fontWeight: .bold,
                                    fontSize: FontSizeToken.lg,
                                    color: context.colors.text,
                                  ),
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                ),
                              ),
                              if (club.isVerified) ...[
                                const SizedBox(width: Spacing.xs),
                                Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: context.colors.info,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: Spacing.xxs),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.calendar,
                                size: 11,
                                color: context.colors.textSubtle,
                              ),
                              const SizedBox(width: Spacing.xs),
                              Text(
                                club.foundedYear?.toString() ?? 'N/A',
                                style: TextStyle(
                                  fontSize: FontSizeToken.sm,
                                  color: context.colors.textSubtle,
                                ),
                              ),
                              const SizedBox(width: Spacing.md),
                              Icon(
                                LucideIcons.chevronRight,
                                size: 14,
                                color: context.colors.textSubtle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
