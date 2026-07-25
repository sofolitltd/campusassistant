import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../data/models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.read(cartProvider.notifier).totalAmount;

    if (cartItems.isEmpty) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.shoppingCart, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Add some products to get started!', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
          ),
        ),
      );
    }

    final groupedByMerchant = <String, List<CartItem>>{};
    for (final item in cartItems) {
      groupedByMerchant.putIfAbsent(item.product.merchantId, () => []).add(item);
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: groupedByMerchant.entries.map((entry) {
          final merchant = entry.value.first.product.merchant;
          return _MerchantGroup(
            merchantId: entry.key,
            merchantName: merchant?.businessName ?? 'Campus Assistant',
            logoUrl: merchant?.logoUrl,
            isPlatform: merchant?.isPlatform ?? true,
            items: entry.value,
            ref: ref,
          );
        }).toList(),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('৳$totalAmount', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () => context.push(AppRoute.marketplaceCheckout.path),
               
                    child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    
        ),
      ),
    );
  }
}

class _MerchantGroup extends StatelessWidget {
  final String merchantId;
  final String merchantName;
  final String? logoUrl;
  final bool isPlatform;
  final List<CartItem> items;
  final WidgetRef ref;

  const _MerchantGroup({
    required this.merchantId,
    required this.merchantName,
    required this.logoUrl,
    required this.isPlatform,
    required this.items,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(RadiusToken.md),
              child: InkWell(
                borderRadius: BorderRadius.circular(RadiusToken.md),
                onTap: isPlatform
                    ? null
                    : () => context.pushNamed(
                          AppRoute.marketplaceMerchantProfile.name,
                          pathParameters: {'merchantId': merchantId},
                        ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusToken.md),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                        child: logoUrl != null && logoUrl!.isNotEmpty
                            ? Image.network(
                                logoUrl!,
                                width: 28,
                                height: 28,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 28,
                                  height: 28,
                                  color: Colors.grey.shade100,
                                  child: Icon(LucideIcons.store, size: 16, color: Colors.grey),
                                ),
                              )
                            : Container(
                                width: 28,
                                height: 28,
                                color: Colors.grey.shade100,
                                child: Icon(LucideIcons.store, size: 16, color: Colors.grey),
                              ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(merchantName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      if (!isPlatform) Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ...items.map((item) => _CartItemTile(item: item, ref: ref)),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final WidgetRef ref;

  const _CartItemTile({required this.item, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 56,
              height: 56,
              child: item.product.imageUrls.isNotEmpty
                  ? Image.network(item.product.imageUrls.first, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(LucideIcons.shoppingBag, color: Colors.grey.shade300))
                  : Icon(LucideIcons.shoppingBag, color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 2),
                Text('৳${item.product.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.minus, size: 18),
                onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity - 1),
              ),
              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(LucideIcons.plus, size: 18),
                onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
