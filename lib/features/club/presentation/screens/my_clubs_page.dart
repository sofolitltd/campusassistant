import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/club/domain/entities/club.dart';
import '/features/club/presentation/providers/club_management_provider.dart';
import '/features/club/presentation/widgets/contact_admin_banner.dart';
import '/routes/app_route.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

/// Clubs the current user requested (suggested) or co-manages. Tapping any
/// of them — pending or active — opens Manage Club, since the requester is
/// meant to keep refining a pending club's info/events/posts while it
/// awaits admin review (see backend SuggestClub, which seeds them as
/// "owner" immediately).
class MyClubsPage extends ConsumerWidget {
  const MyClubsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsync = ref.watch(myClubsProvider);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Scaffold(
          appBar: AppBar(title: const Text('My Clubs')),
          body: clubsAsync.when(
            data: (clubs) {
              if (clubs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.xxxl),
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(
                          Icons.groups_outlined,
                          size: 56,
                          color: context.colors.textSubtle,
                        ),
                        const SizedBox(height: Spacing.md),
                        Text(
                          'You haven\'t suggested or joined managing any club '
                          'yet.',
                          textAlign: .center,
                          style: TextStyle(color: context.colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(Spacing.lg),
                itemCount: clubs.length,
                separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
                itemBuilder: (context, i) => _MyClubCard(club: clubs[i]),
              );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }
}

class _MyClubCard extends StatelessWidget {
  final Club club;

  const _MyClubCard({required this.club});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoute.manageClub.name,
        pathParameters: {'clubId': club.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: club.logoUrl != null && club.logoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(RadiusToken.xxxl),
                      child: CachedNetworkImage(
                        imageUrl: ApiEndpoints.resolveImageUrl(club.logoUrl),
                        fit: .cover,
                      ),
                    )
                  : Icon(Icons.groups, color: context.colors.textSubtle),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    club.name,
                    style: const TextStyle(fontWeight: .bold),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  const SizedBox(height: Spacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: club.isActive
                          ? context.colors.success.withValues(alpha: 0.12)
                          : context.colors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(RadiusToken.xxl),
                    ),
                    child: Text(
                      club.isActive ? 'Active' : 'Pending Review',
                      style: TextStyle(
                        fontSize: FontSizeToken.xs,
                        fontWeight: .w600,
                        color: club.isActive
                            ? context.colors.success
                            : context.colors.warning,
                      ),
                    ),
                  ),
                  if (!club.isActive) ...[
                    const SizedBox(height: Spacing.sm),
                    const ContactAdminBanner(compact: true),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.colors.textSubtle),
          ],
        ),
      ),
    );
  }
}
