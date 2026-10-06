import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/features/association/domain/entities/association.dart';
import '/features/association/presentation/providers/association_provider.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class AssociationsPage extends ConsumerWidget {
  const AssociationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomHeaderLayout(
      title: 'Associations',
      searchHint: 'Search associations...',
      actions: [
        IconButton(
          icon: Icon(LucideIcons.heart, color: context.colors.onPrimary),
          tooltip: 'Joined Associations',
          onPressed: () => context.push(AppRoute.joinedAssociations.path),
        ),
        IconButton(
          icon: Icon(LucideIcons.plus, color: context.colors.onPrimary),
          tooltip: 'Suggest an Association',
          onPressed: () => context.push(AppRoute.suggestAssociation.path),
        ),
      ],
      body: const AssociationsList(),
    );
  }
}

const _associationCategories = [
  'Regional Welfare',
  'Cultural',
  'Sports',
  'Social Service',
  'Academic',
  'Networking',
  'Other',
];

class AssociationsList extends ConsumerStatefulWidget {
  const AssociationsList({super.key});

  @override
  ConsumerState<AssociationsList> createState() => _AssociationsListState();
}

class _AssociationsListState extends ConsumerState<AssociationsList> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final asyncAssociations = ref.watch(associationsListProvider);

    return asyncAssociations.when(
      data: (allAssociations) {
        final categoriesPresent = _associationCategories
            .where((c) => allAssociations.any((a) => a.category == c))
            .toList();
        final associations = _selectedCategory == null
            ? allAssociations
            : allAssociations
                  .where((a) => a.category == _selectedCategory)
                  .toList();

        if (allAssociations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Icon(
                  LucideIcons.landmark,
                  size: 64,
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.5),
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  'No associations found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: .bold,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  'Be the first to add one!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            const _SuggestedAssociationsRow(),
            if (categoriesPresent.isNotEmpty)
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: .horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                  children: [
                    _CategoryChip(
                      label: 'All',
                      selected: _selectedCategory == null,
                      onTap: () => setState(() => _selectedCategory = null),
                    ),
                    ...categoriesPresent.map(
                      (cat) => _CategoryChip(
                        label: cat,
                        selected: _selectedCategory == cat,
                        onTap: () => setState(() => _selectedCategory = cat),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: Spacing.sm),
            Expanded(
              child: associations.isEmpty
                  ? Center(
                      child: Text(
                        'No associations in this category',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.lg,
                        0,
                        Spacing.lg,
                        100,
                      ),
                      itemCount: associations.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: Spacing.lg),
                      itemBuilder: (context, index) =>
                          AssociationCard(association: associations[index]),
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _SuggestedAssociationsRow extends ConsumerWidget {
  const _SuggestedAssociationsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestedAsync = ref.watch(suggestedAssociationsProvider);

    return suggestedAsync.when(
      data: (suggested) {
        if (suggested.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: Spacing.md),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                child: Text(
                  'Suggested for you',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                itemCount: suggested.length,
                separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
                itemBuilder: (context, index) =>
                    _SuggestedAssociationTile(association: suggested[index]),
              ),
              const SizedBox(height: Spacing.md),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _SuggestedAssociationTile extends StatelessWidget {
  final Association association;

  const _SuggestedAssociationTile({required this.association});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isSubDistrictMatch = association.associationType == 'sub_district';
    final locationLabel = isSubDistrictMatch
        ? '${association.subDistrictName}, ${association.districtName}'
        : association.districtName;
    final matchLabel = isSubDistrictMatch
        ? 'Matches your sub-district — join to stay updated'
        : 'Matches your district — join to stay updated';

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoute.associationDetails.name,
          pathParameters: {'associationId': association.id},
          extra: association,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.border, width: 1.0),
        ),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.colors.surfaceAlt,
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.border, width: 2),
              ),
              child:
                  association.logoUrl != null && association.logoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(RadiusToken.xxl),
                      child: CachedNetworkImage(
                        imageUrl: ApiEndpoints.resolveImageUrl(
                          association.logoUrl,
                        ),
                        fit: .cover,
                        errorWidget: (context, url, error) => Icon(
                          LucideIcons.landmark,
                          color: context.colors.textSubtle,
                          size: 20,
                        ),
                      ),
                    )
                  : Icon(
                      LucideIcons.landmark,
                      color: context.colors.textSubtle,
                      size: 20,
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
                          association.name,
                          style: TextStyle(
                            fontWeight: .bold,
                            fontSize: FontSizeToken.base,
                            color: context.colors.text,
                          ),
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                      ),
                      if (association.isVerified) ...[
                        const SizedBox(width: Spacing.xs),
                        Icon(
                          Icons.verified,
                          size: 13,
                          color: context.colors.info,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: 11,
                        color: context.colors.textSubtle,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Expanded(
                        child: Text(
                          locationLabel,
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: TextStyle(
                            fontSize: FontSizeToken.sm,
                            color: context.colors.textSubtle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    matchLabel,
                    style: TextStyle(
                      fontSize: FontSizeToken.xs,
                      fontWeight: .w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: context.colors.textSubtle,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.only(right: Spacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          decoration: BoxDecoration(
            color: selected ? primaryColor : (context.colors.surfaceAlt),
            borderRadius: BorderRadius.circular(RadiusToken.xl),
            border: Border.all(
              color: selected ? primaryColor : (context.colors.borderStrong),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: FontSizeToken.sm,
              fontWeight: .w600,
              color: selected
                  ? context.colors.onPrimary
                  : (context.colors.textMuted),
            ),
          ),
        ),
      ),
    );
  }
}

class AssociationCard extends StatelessWidget {
  final Association association;

  const AssociationCard({super.key, required this.association});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final locationLabel = association.associationType == 'sub_district'
        ? '${association.subDistrictName}, ${association.districtName}'
        : association.districtName;

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoute.associationDetails.name,
          pathParameters: {'associationId': association.id},
          extra: association,
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
              association.bannerUrl != null && association.bannerUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: ApiEndpoints.resolveImageUrl(
                        association.bannerUrl,
                      ),
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
                      child:
                          association.logoUrl != null &&
                              association.logoUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                RadiusToken.xxxl,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: ApiEndpoints.resolveImageUrl(
                                  association.logoUrl,
                                ),
                                fit: .cover,
                                errorWidget: (context, url, error) => Icon(
                                  LucideIcons.landmark,
                                  color: context.colors.textSubtle,
                                  size: 22,
                                ),
                              ),
                            )
                          : Icon(
                              LucideIcons.landmark,
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
                                  association.name,
                                  style: TextStyle(
                                    fontWeight: .bold,
                                    fontSize: FontSizeToken.lg,
                                    color: context.colors.text,
                                  ),
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                ),
                              ),
                              if (association.isVerified) ...[
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
                                LucideIcons.mapPin,
                                size: 11,
                                color: context.colors.textSubtle,
                              ),
                              const SizedBox(width: Spacing.xs),
                              Expanded(
                                child: Text(
                                  locationLabel,
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                  style: TextStyle(
                                    fontSize: FontSizeToken.sm,
                                    color: context.colors.textSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Spacing.sm),
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
