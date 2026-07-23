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

class ProductListScreen extends ConsumerWidget {
  final String? categoryId;
  final Category? category;

  const ProductListScreen({super.key, this.categoryId, this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;

    if (user == null) return const Center(child: CupertinoActivityIndicator());

    final productsAsync = ref.watch(
      categoryId != null
          ? productsListByCategoryProvider((
              universityId: user.university,
              departmentId: user.department,
              categoryId: categoryId!,
            ))
          : productsListProvider((
              universityId: user.university,
              departmentId: user.department,
            )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? 'Products'),
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products in this category.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
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
        error: (e, _) => Center(child: Text('Could not load products.')),
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
