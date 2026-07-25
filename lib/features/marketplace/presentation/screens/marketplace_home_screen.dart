import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../providers/marketplace_provider.dart';

class MarketplaceHomeScreen extends ConsumerWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;
    final categoriesAsync = ref.watch(categoriesListProvider);

    if (user == null) return const Center(child: CupertinoActivityIndicator());

    final productsAsync = ref.watch(
      productsListProvider((universityId: user.university, departmentId: user.department)),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Campus Market'),),
      body: CustomScrollView(
        slivers: [
          // Hero info section
          const SliverToBoxAdapter(child: _MarketplaceHeroSectionWrapper()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Category rail
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {},
                            child: const Text('See all'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, i) => _CategoryChip(
                            category: categories[i],
                            onTap: () => context.push(
                              '/campusmarket/category/${categories[i].id}',
                              extra: {
                                'category': categories[i],
                                'universityId': user.university,
                                'departmentId': user.department,
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox(height: 80, child: Center(child: CupertinoActivityIndicator())),
                error: (e, _) => const SizedBox.shrink(),
              ),
            ),
          ),

          // Product grid header
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('All Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Product grid
          ...productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return [
                  const SliverToBoxAdapter(
                    child: Center(child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No products yet. Check back soon!'),
                    )),
                  ),
                ];
              }
              return [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final crossAxisCount = width >= 640 ? 4 : width >= 480 ? 3 : 2;
                      return SliverMasonryGrid.count(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childCount: products.length,
                        itemBuilder: (context, i) => _ProductGridCard(product: products[i]),
                      );
                    },
                  ),
                ),
              ];
            },
            loading: () => [
              const SliverToBoxAdapter(
                child: SizedBox(height: 200, child: Center(child: CupertinoActivityIndicator())),
              ),
            ],
            error: (e, _) => [
              const SliverToBoxAdapter(
                child: SizedBox(height: 200, child: Center(child: Text('Could not load products.'))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MarketplaceHeroSectionWrapper extends ConsumerWidget {
  const _MarketplaceHeroSectionWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dismissedAsync = ref.watch(marketplaceHeroDismissedProvider);
    final dismissed = dismissedAsync.asData?.value ?? false;
    if (dismissed) return const SizedBox.shrink();
    return _MarketplaceHeroSection();
  }
}

class _MarketplaceHeroSection extends ConsumerWidget {
  const _MarketplaceHeroSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 12, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
              primaryColor.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(
            color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(LucideIcons.store, size: 16, color: primaryColor),
                      ),
                      const SizedBox(width: 8),
                      Text('Campus Market', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A campus-exclusive marketplace for students, faculty & staff.',
                    style: TextStyle(fontSize: 12, height: 1.4, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 28,
                    child: OutlinedButton.icon(
                      onPressed: () => context.pushNamed(AppRoute.marketplaceInfo.name),
                      icon: const Icon(LucideIcons.info, size: 12),
                      label: const Text('Learn More', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        visualDensity: VisualDensity.compact,
                        side: BorderSide(color: primaryColor.withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusToken.md)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                await const FlutterSecureStorage().write(key: 'marketplace_hero_dismissed', value: 'true');
                ref.invalidate(marketplaceHeroDismissedProvider);
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(LucideIcons.x, size: 16, color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const _CategoryChip({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(ApiEndpoints.resolveImageUrl(category.imageUrl), width: 28, height: 28, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(LucideIcons.layers, size: 20, color: Colors.grey.shade400)),
              )
            else
              Icon(LucideIcons.layers, size: 20, color: Colors.grey.shade400),
            const SizedBox(height: 4),
            Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  final Product product;
  const _ProductGridCard({required this.product});

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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(RadiusToken.lg)),
              child: SizedBox(
                width: double.infinity,
                height: 150,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        ApiEndpoints.resolveImageUrl(imageUrl),
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
