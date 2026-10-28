import 'package:material_ui/material_ui.dart';

import '/core/widgets/app_loader.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/rating_widgets.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '../widgets/market_product_card.dart';
import '../widgets/market_theme.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import '/core/widgets/app_network_image.dart';

class MerchantProfileScreen extends ConsumerWidget {
  final String merchantId;
  const MerchantProfileScreen({super.key, required this.merchantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantAsync = ref.watch(merchantByIdProvider(merchantId));
    final productsAsync = ref.watch(merchantProductsProvider(merchantId));

    return HeaderGradientBackdrop(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Merchant'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: MarketBody(
          child: merchantAsync.when(
            loading: () => const Center(child: AppLoader()),
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
                          backgroundColor: Theme.of(context).colorScheme.primary
                              .withValues(alpha: 0.12),
                          backgroundImage: merchant.logoUrl.isNotEmpty
                              ? AppNetworkImage.provider(
                                  ApiEndpoints.resolveImageUrl(
                                    merchant.logoUrl,
                                  ),
                                )
                              : null,
                          child: merchant.logoUrl.isEmpty
                              ? Icon(
                                  LucideIcons.store,
                                  color: Theme.of(context).colorScheme.primary,
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
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
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: .bold),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: Spacing.sm)),
                productsAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(Spacing.xxxl),
                      child: Center(child: AppLoader()),
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
                            child: Text('No products from this merchant yet.'),
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
                                MarketProductCard(product: products[i]),
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
    );
  }
}
