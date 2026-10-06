import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/domain/entities/user.dart' as user_entity;
import '/routes/app_route.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';

import '../../../../core/theme/tokens/app_spacing.dart';
import 'profile_completion_card.dart';
import '/core/theme/tokens/app_font_size.dart';

class HeaderCard extends StatelessWidget {
  final user_entity.User user;

  const HeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isPro = user.subscriptionStatus == 'pro';
    final planLabel = isPro ? 'Pro' : 'Basic';
    final planColor = context.colors.textMuted;
    final isProfileComplete = profileCompletionPercent(user) == 100;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor
            : context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.lg),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? context.colors.border
              : context.colors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: .center,
        children: [
          _ProfileImage(imageUrl: user.profileImage ?? ''),
          SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                Text(
                  user.fullName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: FontSizeToken.lg,
                    fontWeight: .bold,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        border: Border.all(color: context.colors.borderStrong),
                        borderRadius: BorderRadius.circular(RadiusToken.xxl),
                      ),
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          Icon(LucideIcons.trophy, size: 14, color: planColor),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            planLabel,
                            style: TextStyle(
                              fontSize: FontSizeToken.sm,
                              fontWeight: .w600,
                              color: planColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isProfileComplete) ...[
                      const SizedBox(width: Spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          border: Border.all(
                            color: context.colors.borderStrong,
                          ),
                          borderRadius: BorderRadius.circular(RadiusToken.xxl),
                        ),
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            Icon(
                              LucideIcons.circleCheck,
                              size: 14,
                              color: context.colors.success,
                            ),
                            const SizedBox(width: Spacing.sm),
                            Text(
                              '100%',
                              style: TextStyle(
                                fontSize: FontSizeToken.sm,
                                fontWeight: .w600,
                                color: context.colors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          AppRoute.editProfile.name,
                          queryParameters: {'uid': user.id},
                        );
                      },
                      child: Icon(
                        LucideIcons.pencil,
                        size: 18,
                        color: context.colors.primary,
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

class _ProfileImage extends StatelessWidget {
  final String imageUrl;
  const _ProfileImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: .none,
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF4A3A4), // Pinkish color from design
            shape: BoxShape.circle,
          ),
          clipBehavior: .antiAlias,
          child: imageUrl.isEmpty
              ? Center(
                  child: Icon(
                    Icons.person_outline,
                    size: 40,
                    color: context.colors.onPrimary,
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: ApiEndpoints.resolveImageUrl(imageUrl),
                  fit: .cover,
                  placeholder: (context, url) => Center(
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                      color: context.colors.onPrimary,
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                      color: context.colors.onPrimary,
                    ),
                  ),
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(Spacing.xs),
            decoration: BoxDecoration(
              color: context.colors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.border, width: 1),
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 14,
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
