import 'package:cached_network_image/cached_network_image.dart';
import '/core/widgets/custom_header_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '/core/network/api_endpoints.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/routes/app_route.dart';
import '../../data/models/lost_found_claim.dart';
import '../../data/models/lost_found_item.dart';
import '../providers/lost_found_provider.dart';
import '../widgets/claim_bottom_sheet.dart';
import '../widgets/report_bottom_sheet.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class LostFoundDetailScreen extends ConsumerWidget {
  final String itemId;
  const LostFoundDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(lostFoundRefreshProvider);
    final itemAsync = ref.watch(lostFoundItemDetailProvider(itemId));
    final currentUser = ref.watch(currentUserProvider).value;

    return CustomHeaderLayout(
      title: 'Item Details',
      showSearchBar: false,
      actions: [
        itemAsync.maybeWhen(
          data: (item) => currentUser != null && currentUser.id != item.posterId
              ? IconButton(
                  icon: Icon(
                    Icons.flag_outlined,
                    color: context.colors.onPrimary,
                  ),
                  tooltip: 'Report',
                  onPressed: () => showReportBottomSheet(context, ref, itemId),
                )
              : const SizedBox.shrink(),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
      body: itemAsync.when(
        data: (item) {
          final isOwner =
              currentUser != null && currentUser.id == item.posterId;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                if (item.imageUrls.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: PageView(
                      children: item.imageUrls
                          .map(
                            (url) => CachedNetworkImage(
                              imageUrl: ApiEndpoints.resolveImageUrl(url),
                              fit: .cover,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              item.type == LostFoundType.lost
                                  ? 'LOST'
                                  : 'FOUND',
                            ),
                            backgroundColor: item.type == LostFoundType.lost
                                ? context.colors.warning
                                : context.colors.primary,
                            labelStyle: TextStyle(
                              color: context.colors.onPrimary,
                              fontWeight: .bold,
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Chip(label: Text(item.status.name.toUpperCase())),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(item.description),
                      const SizedBox(height: Spacing.md),
                      if (item.location.isNotEmpty)
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16),
                            const SizedBox(width: Spacing.xs),
                            Text(item.location),
                          ],
                        ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        'Posted ${timeago.format(item.createdAt)} by ${item.poster?.name ?? "a student"}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (item.status == LostFoundStatus.removed &&
                          item.removalReason != null) ...[
                        const SizedBox(height: Spacing.md),
                        Container(
                          padding: const EdgeInsets.all(Spacing.md),
                          decoration: BoxDecoration(
                            color: context.colors.danger.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(RadiusToken.md),
                          ),
                          child: Text(
                            'Removed by moderators: ${item.removalReason}',
                          ),
                        ),
                      ],
                      const SizedBox(height: Spacing.xl),
                      if (isOwner)
                        _OwnerActions(item: item)
                      else if (item.status == LostFoundStatus.open)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () =>
                                showClaimBottomSheet(context, ref, itemId),
                            icon: const Icon(Icons.pan_tool_alt_outlined),
                            label: Text(
                              item.type == LostFoundType.lost
                                  ? "I found this"
                                  : "This is mine",
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load item: $err')),
      ),
    );
  }
}

class _OwnerActions extends ConsumerWidget {
  final LostFoundItem item;
  const _OwnerActions({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final claimsAsync = ref.watch(lostFoundClaimsProvider(item.id));

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Text('Claims', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            if (item.status != LostFoundStatus.resolved &&
                item.status != LostFoundStatus.removed)
              TextButton.icon(
                onPressed: () async {
                  await ref.read(lostFoundActionsProvider).resolveItem(item.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marked as resolved')),
                    );
                  }
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Mark Resolved'),
              ),
          ],
        ),
        claimsAsync.when(
          data: (claims) => claims.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: Spacing.md),
                  child: Text('No claims yet.'),
                )
              : Column(
                  children: claims
                      .map((claim) => _ClaimTile(item: item, claim: claim))
                      .toList(),
                ),
          loading: () => const Padding(
            padding: EdgeInsets.all(Spacing.md),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Text('Failed to load claims: $err'),
        ),
      ],
    );
  }
}

class _ClaimTile extends ConsumerWidget {
  final LostFoundItem item;
  final LostFoundClaim claim;
  const _ClaimTile({required this.item, required this.claim});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              claim.claimer?.name ?? 'Student',
              style: const TextStyle(fontWeight: .bold),
            ),
            if (claim.message.isNotEmpty) ...[
              const SizedBox(height: Spacing.xs),
              Text(claim.message),
            ],
            const SizedBox(height: Spacing.sm),
            if (claim.status == LostFoundClaimStatus.pending)
              Row(
                children: [
                  FilledButton(
                    onPressed: () async {
                      final conversationId = await ref
                          .read(lostFoundActionsProvider)
                          .acceptClaim(item.id, claim.id);
                      if (context.mounted && conversationId != null) {
                        context.pushNamed(
                          AppRoute.inboxChat.name,
                          pathParameters: {'conversationId': conversationId},
                          extra: {
                            'name': claim.claimer?.name ?? 'Student',
                            'otherUserId': claim.claimerId,
                            'status': 'accepted',
                          },
                        );
                      }
                    },
                    child: const Text('Accept & Chat'),
                  ),
                  const SizedBox(width: Spacing.sm),
                  OutlinedButton(
                    onPressed: () => ref
                        .read(lostFoundActionsProvider)
                        .rejectClaim(item.id, claim.id),
                    child: const Text('Reject'),
                  ),
                ],
              )
            else
              Chip(label: Text(claim.status.name.toUpperCase())),
          ],
        ),
      ),
    );
  }
}
