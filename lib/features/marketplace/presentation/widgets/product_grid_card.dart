import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import 'market_product_card.dart';

/// A single marketplace product — public, drop-in grid card. Tap navigates
/// to the product details route (built in, no external onTap wiring
/// needed). Used by both `ProductListScreen` and the global search results
/// page. Same card as the market home, so every listing looks alike.
class ProductGridCard extends StatelessWidget {
  final Product product;
  const ProductGridCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) => MarketProductCard(product: product);
}
