import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../data/models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product? product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final _pageController = PageController();
  int _imageIndex = 0;
  int _quantity = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: isError ? 2 : 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Campus Marketplace')),
        body: const Center(child: Text('Product not found.')),
      );
    }

    final images = product.imageUrls;
    final inStock = product.stock > 0;
    final merchantName = product.merchant?.isPlatform == true
        ? 'Campus Assistant'
        : product.merchant?.businessName ?? '';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            actionsIconTheme: const IconThemeData(color: Colors.white),
            actions: [
              _CartAction(),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  images.isNotEmpty
                      ? PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          onPageChanged: (i) => setState(() => _imageIndex = i),
                          itemBuilder: (context, i) => Image.network(
                            images[i],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey.shade300,
                              child: Icon(LucideIcons.shoppingBag, size: 48, color: Colors.grey.shade500),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          child: Icon(LucideIcons.shoppingBag, size: 48, color: Colors.grey.shade500),
                        ),
                  // Scrim so the back/cart icons stay legible over bright photos.
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 90,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black45, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (i) {
                          final active = i == _imageIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: active ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: active ? Colors.white : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _StockChip(inStock: inStock),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '৳${product.price}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'per unit',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                    if (merchantName.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Material(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(RadiusToken.md),
                          onTap: () => context.pushNamed(
                            AppRoute.marketplaceMerchantProfile.name,
                            pathParameters: {'merchantId': product.merchantId},
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                                  child: Icon(LucideIcons.store, size: 16, color: theme.colorScheme.primary),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sold by',
                                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                                      ),
                                      Text(
                                        merchantName,
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey.shade500),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (product.description.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Description', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text('Quantity', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _QuantityStepper(
                      quantity: _quantity,
                      maxQuantity: product.stock,
                      enabled: inStock,
                      onChanged: (q) => setState(() => _quantity = q),
                    ),
                    // Spacer so content isn't hidden behind the fixed bottom bar.
                    const SizedBox(height: 88),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BuyBar(
        onAddToCart: () {
          if (!inStock) {
            _showSnack('This product is out of stock.', isError: true);
            return;
          }
          ref.read(cartProvider.notifier).addItem(product, quantity: _quantity);
          _showSnack('Added to cart');
        },
        onBuyNow: () {
          if (!inStock) {
            _showSnack('This product is out of stock.', isError: true);
            return;
          }
          ref.read(cartProvider.notifier).addItem(product, quantity: _quantity);
          context.push(AppRoute.marketplaceCheckout.path);
        },
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  final bool inStock;
  const _StockChip({required this.inStock});

  @override
  Widget build(BuildContext context) {
    final color = inStock ? Colors.green.shade700 : Colors.red.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
      child: Text(
        inStock ? 'In stock' : 'Out of stock',
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({
    required this.quantity,
    required this.maxQuantity,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canIncrement = enabled && quantity < maxQuantity;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StepButton(
                icon: LucideIcons.minus,
                onTap: enabled && quantity > 1 ? () => onChanged(quantity - 1) : null,
              ),
              Container(
                width: 48,
                alignment: Alignment.center,
                child: Text('$quantity', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
              _StepButton(
                icon: LucideIcons.plus,
                onTap: canIncrement ? () => onChanged(quantity + 1) : null,
              ),
            ],
          ),
          if (enabled && maxQuantity > 0) ...[
            const SizedBox(height: 6),
            Text(
              'Only $maxQuantity left in stock',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(RadiusToken.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.sm),
        onTap: onTap,
        child: SizedBox(width: 36, height: 36, child: Icon(icon, size: 16)),
      ),
    );
  }
}

class _BuyBar extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _BuyBar({required this.onAddToCart, required this.onBuyNow});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.4))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(LucideIcons.shoppingCart, size: 18),
                    label: const Text('Add to Cart'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(color: theme.colorScheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusToken.md)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: onBuyNow,
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusToken.md)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Buy Now'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartAction extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider.select(
      (items) => items.fold<int>(0, (sum, item) => sum + item.quantity),
    ));

    return IconButton(
      tooltip: 'Go to cart',
      onPressed: () => context.push(AppRoute.marketplaceCart.path),
      icon: Badge(
        label: Text('$cartCount'),
        isLabelVisible: cartCount > 0,
        child: const Icon(LucideIcons.shoppingCart),
      ),
    );
  }
}
