import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../data/models/product.dart';
import '../providers/marketplace_provider.dart';

class MerchantProfileScreen extends ConsumerWidget {
  final String merchantId;
  const MerchantProfileScreen({super.key, required this.merchantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantAsync = ref.watch(merchantByIdProvider(merchantId));
    final productsAsync = ref.watch(merchantProductsProvider(merchantId));

    return Scaffold(
      appBar: AppBar(title: const Text('Merchant')),
      body: merchantAsync.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => const Center(child: Text('Could not load this merchant.')),
        data: (merchant) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                      backgroundImage: merchant.logoUrl.isNotEmpty ? NetworkImage(merchant.logoUrl) : null,
                      child: merchant.logoUrl.isEmpty
                          ? Icon(LucideIcons.store, color: Theme.of(context).colorScheme.primary)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            merchant.isPlatform ? 'Campus Assistant' : merchant.businessName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (merchant.businessType.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              merchant.businessType,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          if (merchant.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              merchant.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Text('Products', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            productsAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CupertinoActivityIndicator()),
                ),
              ),
              error: (e, _) => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('Could not load products.')),
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('No products from this merchant yet.')),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _MerchantProductCard(product: products[i]),
                      childCount: products.length,
                    ),
                  ),
                );
              },
            ),
          ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrl = product.imageUrls.isNotEmpty ? product.imageUrls.first : '';

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
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(RadiusToken.lg)),
                child: SizedBox(
                  width: double.infinity,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade100,
                            child: Icon(LucideIcons.shoppingBag, color: Colors.grey.shade400),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade100,
                          child: Icon(LucideIcons.shoppingBag, color: Colors.grey.shade400),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.2),
                  ),
                  const SizedBox(height: 4),
                  Text('৳${product.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
