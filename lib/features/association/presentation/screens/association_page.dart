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

class AssociationsPage extends ConsumerWidget {
  const AssociationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomHeaderLayout(
      title: 'Associations',
      searchHint: 'Search associations...',
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.heart, color: Colors.white),
          tooltip: 'Joined Associations',
          onPressed: () => context.push(AppRoute.joinedAssociations.path),
        ),
        IconButton(
          icon: const Icon(LucideIcons.plus, color: Colors.white),
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 8),
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
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
            const SizedBox(height: 8),
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
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: associations.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
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
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Suggested for you',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: suggested.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => SizedBox(
                    width: 220,
                    child: AssociationCard(association: suggested[index]),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected
                ? primaryColor
                : (isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? primaryColor
                  : (isDark ? Colors.white10 : Colors.grey.shade300),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.grey.shade700),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              association.bannerUrl != null &&
                      association.bannerUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: ApiEndpoints.resolveImageUrl(
                        association.bannerUrl,
                      ),
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
                          color: isDark
                              ? Colors.white10
                              : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child:
                          association.logoUrl != null &&
                              association.logoUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: CachedNetworkImage(
                                imageUrl: ApiEndpoints.resolveImageUrl(
                                  association.logoUrl,
                                ),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Icon(
                                  LucideIcons.landmark,
                                  color: Colors.grey.shade400,
                                  size: 22,
                                ),
                              ),
                            )
                          : Icon(
                              LucideIcons.landmark,
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
                                  association.name,
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
                              if (association.isVerified) ...[
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
                                LucideIcons.mapPin,
                                size: 11,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  locationLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
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
