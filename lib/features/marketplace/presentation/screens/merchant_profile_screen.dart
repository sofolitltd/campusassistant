import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/routes/app_route.dart';
import '../../data/models/product.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/rating_widgets.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '../widgets/market_theme.dart';

class MerchantProfileScreen extends ConsumerWidget {
  final String merchantId;
  const MerchantProfileScreen({super.key, required this.merchantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantAsync = ref.watch(merchantByIdProvider(merchantId));
    final productsAsync = ref.watch(merchantProductsProvider(merchantId));

    return Scaffold(
      appBar: AppBar(title: const Text('Merchant')),
      backgroundColor: context.colors.primary,
      body: MarketBody(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: merchantAsync.when(
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) =>
                  const Center(child: Text('Could not load this merchant.')),
              data: (merchant) => CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.xl),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.12),
                            backgroundImage: merchant.logoUrl.isNotEmpty
                                ? NetworkImage(
                                    ApiEndpoints.resolveImageUrl(
                                      merchant.logoUrl,
                                    ),
                                  )
                                : null,
                            child: merchant.logoUrl.isEmpty
                                ? Icon(
                                    LucideIcons.store,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  )
                                : null,
                          ),
                          const SizedBox(width: Spacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  merchant.isPlatform
                                      ? 'Campus Assistant'
                                      : merchant.businessName,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: .bold),
                                ),
                                if (merchant.businessType.isNotEmpty) ...[
                                  const SizedBox(height: Spacing.xxs),
                                  Text(
                                    merchant.businessType,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontSize: FontSizeToken.sm,
                                      fontWeight: .w600,
                                    ),
                                  ),
                                ],
                                if (merchant.ratingCount > 0) ...[
                                  const SizedBox(height: Spacing.xs),
                                  RatingBadge(
                                    average: merchant.ratingAvg,
                                    count: merchant.ratingCount,
                                    size: 13,
                                  ),
                                ],
                                if (merchant.isFastShipper) ...[
                                  const SizedBox(height: Spacing.sm),
                                  const TrustChip(
                                    icon: LucideIcons.zap,
                                    label: 'Fast shipper',
                                  ),
                                ],
                                if (merchant.description.isNotEmpty) ...[
                                  const SizedBox(height: Spacing.xs),
                                  Text(
                                    merchant.description,
                                    maxLines: 3,
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: context.colors.textMuted,
                                      fontSize: FontSizeToken.md,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Products',
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: Spacing.sm)),
                  productsAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(Spacing.xxxl),
                        child: Center(child: CupertinoActivityIndicator()),
                      ),
                    ),
                    error: (e, _) => const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(Spacing.xxxl),
                        child: Center(child: Text('Could not load products.')),
                      ),
                    ),
                    data: (products) {
                      if (products.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(Spacing.xxxl),
                            child: Center(
                              child: Text(
                                'No products from this merchant yet.',
                              ),
                            ),
                          ),
                        );
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          Spacing.xl,
                          0,
                          Spacing.xl,
                          Spacing.xl,
                        ),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.crossAxisExtent;
                            final crossAxisCount = width >= 640
                                ? 4
                                : width >= 480
                                ? 3
                                : 2;
                            return SliverMasonryGrid.count(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childCount: products.length,
                              itemBuilder: (context, i) =>
                                  _MerchantProductCard(product: products[i]),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MerchantProductCard extends StatelessWidget {
  final Product product;
  const _MerchantProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrls.isNotEmpty
        ? product.imageUrls.first
        : '';

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoute.marketplaceProductDetails.name,
        pathParameters: {'productId': product.id},
        extra: product,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(RadiusToken.lg),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          ApiEndpoints.resolveImageUrl(imageUrl),
                          fit: .cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: context.colors.surfaceAlt,
                                child: Icon(
                                  LucideIcons.shoppingBag,
                                  color: context.colors.textSubtle,
                                ),
                              ),
                        )
                      : Container(
                          color: context.colors.surfaceAlt,
                          child: Icon(
                            LucideIcons.shoppingBag,
                            color: context.colors.textSubtle,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: const TextStyle(
                      fontWeight: .w600,
                      fontSize: FontSizeToken.md,
                      height: 1.2,
                    ),
                  ),
                  if (product.ratingCount > 0) ...[
                    const SizedBox(height: Spacing.xs),
                    RatingBadge(
                      average: product.ratingAvg,
                      count: product.ratingCount,
                    ),
                  ],
                  const SizedBox(height: Spacing.xs),
                  Text(
                    '৳${product.price}',
                    style: const TextStyle(
                      fontWeight: .bold,
                      fontSize: FontSizeToken.md,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
