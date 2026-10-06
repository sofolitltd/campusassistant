import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/app_choice_chip.dart';
import '/core/widgets/custom_header_layout.dart';
import '/features/association/domain/entities/association.dart';
import '/features/association/presentation/providers/association_provider.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class AssociationsPage extends ConsumerStatefulWidget {
  const AssociationsPage({super.key});

  @override
  ConsumerState<AssociationsPage> createState() => _AssociationsPageState();
}

class _AssociationsPageState extends ConsumerState<AssociationsPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return CustomHeaderLayout(
      searchAtBottom: true,
      title: 'Associations',
      searchHint: 'Search associations...',
      onSearchChanged: (value) => setState(() => _searchQuery = value),
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
      body: AssociationsList(searchQuery: _searchQuery),
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
  const AssociationsList({super.key, this.searchQuery = ''});

  final String searchQuery;

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
        final query = widget.searchQuery.trim().toLowerCase();
        final associations = allAssociations.where((a) {
          if (_selectedCategory != null && a.category != _selectedCategory) {
            return false;
          }
          if (query.isEmpty) return true;
          return a.name.toLowerCase().contains(query) ||
              a.districtName.toLowerCase().contains(query) ||
              (a.subDistrictName ?? '').toLowerCase().contains(query);
        }).toList();

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
            const SizedBox(height: Spacing.lg),
            const _SuggestedAssociationsRow(),
            if (categoriesPresent.isNotEmpty)
              SizedBox(
                height: AppChoiceChip.rowHeight,
                child: ListView.separated(
                  scrollDirection: .horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                  itemCount: categoriesPresent.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                  itemBuilder: (context, index) {
                    final cat = index == 0
                        ? null
                        : categoriesPresent.elementAt(index - 1);
                    return AppChoiceChip(
                      label: cat ?? 'All',
                      selected: _selectedCategory == cat,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  },
                ),
              ),
            const SizedBox(height: Spacing.lg),
            Expanded(
              child: associations.isEmpty
                  ? Center(
                      child: Text(
                        query.isNotEmpty
                            ? 'No matches found'
                            : 'No associations in this category',
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
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      size: 16,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      'Suggested for you',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                    ),
                  ],
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
    final isSubDistrictMatch = association.associationType == 'sub_district';
    final locationLabel = isSubDistrictMatch
        ? '${association.subDistrictName}, ${association.districtName}'
        : association.districtName;
    final matchLabel = isSubDistrictMatch
        ? 'Matches your sub-district'
        : 'Matches your district';

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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colors.primarySubtle,
              context.colors.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(
            color: context.colors.primary.withValues(alpha: 0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.xxs),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.primary, width: 1.5),
              ),
              child: _AssociationLogo(logoUrl: association.logoUrl),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(RadiusToken.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.mapPinCheck,
                          size: 11,
                          color: context.colors.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Flexible(
                          child: Text(
                            matchLabel,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontSize: FontSizeToken.xs,
                              fontWeight: .w700,
                              color: context.colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: context.colors.primary,
            ),
          ],
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
                padding: const EdgeInsets.all(Spacing.md),
                child: Row(
                  children: [
                    _AssociationLogo(logoUrl: association.logoUrl),
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
                            ],
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular association logo, sized to sit level with the two-line text block
/// beside it.
class _AssociationLogo extends StatelessWidget {
  static const double size = 36;

  final String? logoUrl;

  const _AssociationLogo({required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(
      LucideIcons.landmark,
      color: context.colors.textSubtle,
      size: 18,
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.border),
      ),
      child: logoUrl != null && logoUrl!.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: ApiEndpoints.resolveImageUrl(logoUrl),
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => fallback,
              ),
            )
          : fallback,
    );
  }
}
