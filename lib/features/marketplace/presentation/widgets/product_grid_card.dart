import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../data/models/product.dart';

/// A single marketplace product — public, drop-in grid card. Tap navigates
/// to the product details route (built in, no external onTap wiring
/// needed). Used by both `ProductListScreen` and the global search results
/// page.
class ProductGridCard extends StatelessWidget {
  final Product product;
  const ProductGridCard({super.key, required this.product});

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
