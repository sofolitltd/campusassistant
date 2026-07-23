import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
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
      appBar: AppBar(title: Text('Market Place'),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category rail
            categoriesAsync.when(
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
                          onPressed: () {}, // The shell's Categories tab handles this
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
                            '/marketplace/category/${categories[i].id}',
                            extra: {
                              'category': categories[i],
                              'universityId': user.university,
                              'departmentId': user.department,
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
              loading: () => const SizedBox(height: 80, child: Center(child: CupertinoActivityIndicator())),
              error: (e, _) => const SizedBox.shrink(),
            ),
      
            // Product grid
            const Text('All Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No products yet. Check back soon!'),
                  ));
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) => _ProductGridCard(product: products[i]),
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) => const Center(child: Text('Could not load products.')),
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
                child: Image.network(category.imageUrl, width: 28, height: 28, fit: BoxFit.cover,
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
