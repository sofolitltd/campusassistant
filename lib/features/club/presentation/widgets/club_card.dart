import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/club/domain/entities/club.dart';
import '/routes/app_route.dart';

/// A single club — public, drop-in card. Tap navigates to the club details
/// route (built in, no external onTap wiring needed). Used by both
/// `ClubsList` (club_page.dart) and the global search results page.
class ClubCard extends StatelessWidget {
  final Club club;

  const ClubCard({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RadiusToken.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              club.bannerUrl != null && club.bannerUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: ApiEndpoints.resolveImageUrl(club.bannerUrl),
                      height: 120,
                      fit: BoxFit.cover,
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: club.logoUrl != null && club.logoUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: CachedNetworkImage(
                                imageUrl: ApiEndpoints.resolveImageUrl(
                                  club.logoUrl,
                                ),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Icon(
                                  LucideIcons.users,
                                  color: Colors.grey.shade400,
                                  size: 22,
                                ),
                              ),
                            )
                          : Icon(
                              LucideIcons.users,
                              color: Colors.grey.shade400,
                              size: 22,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  club.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (club.isVerified) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: Colors.blue.shade400,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.calendar,
                                size: 11,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                club.foundedYear?.toString() ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                LucideIcons.chevronRight,
                                size: 14,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade400,
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
