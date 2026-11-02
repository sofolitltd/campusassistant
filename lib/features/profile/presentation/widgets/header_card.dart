import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/domain/entities/user.dart' as user_entity;
import '/routes/app_route.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';

import '../../../../core/theme/tokens/app_spacing.dart';
import 'account_info_dialog.dart';
import 'profile_completion_card.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/widgets/app_network_image.dart';

class HeaderCard extends StatelessWidget {
  final user_entity.User user;

  const HeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isPro = user.subscriptionStatus == 'pro';
    final planLabel = isPro ? 'Pro' : 'Basic';
    final planColor = isPro ? context.colors.primary : context.colors.textMuted;
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
          _ProfileImage(imageUrl: user.profileImage ?? '', userId: user.id),
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
                if (user.highestModeratorRole case final role?) ...[
                  const SizedBox(height: Spacing.xs),
                  InkWell(
                    borderRadius: BorderRadius.circular(RadiusToken.full),
                    onTap: () => _showModeratorRoles(context, user),
                    child: Chip(
                      visualDensity: VisualDensity.compact,
                      avatar: const Icon(LucideIcons.shieldCheck, size: 15),
                      label: Text(
                        '${role.title} · ${role.scopeName}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => showAccountInfoDialog(context, user),
                      child: Container(
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
                              LucideIcons.trophy,
                              size: 14,
                              color: planColor,
                            ),
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
                      child: Container(
                        margin: const EdgeInsets.only(right: Spacing.xs),
                        padding: const EdgeInsets.all(Spacing.xs),
                        decoration:
                            //  isProfileComplete ?
                            BoxDecoration(
                              color: context.colors.surface,
                              border: Border.all(
                                color: context.colors.borderStrong,
                              ),
                              borderRadius: BorderRadius.circular(
                                RadiusToken.xxl,
                              ),
                            ),
                        child: Icon(
                          LucideIcons.pencil,
                          size: 16,
                          color: context.colors.primary,
                        ),
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

void _showModeratorRoles(BuildContext context, user_entity.User user) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: Spacing.lg),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              'Moderator roles',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          for (final role in user.moderatorRoles)
            ListTile(
              leading: const Icon(LucideIcons.shieldCheck),
              title: Text(role.title),
              subtitle: Text(
                role.scopeName +
                    (role.termEnd == null
                        ? ''
                        : ' · Until ${MaterialLocalizations.of(context).formatShortDate(role.termEnd!)}'),
              ),
            ),
        ],
      ),
    ),
  );
}

class _ProfileImage extends StatelessWidget {
  final String imageUrl;
  final String userId;
  const _ProfileImage({required this.imageUrl, required this.userId});

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
              : AppNetworkImage(
                  ApiEndpoints.resolveImageUrl(imageUrl),
                  fit: .cover,
                  placeholder: (context) => Center(
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                      color: context.colors.onPrimary,
                    ),
                  ),
                  errorBuilder: (context, error, _) => Center(
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
          child: GestureDetector(
            onTap: () {
              context.pushNamed(
                AppRoute.editProfile.name,
                queryParameters: {'uid': userId},
              );
            },
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
        ),
      ],
    );
  }
}
