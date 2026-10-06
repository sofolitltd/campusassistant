import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../data/models/cart_item.dart';
import '../providers/cart_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '../widgets/market_theme.dart';

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
            backgroundColor: context.colors.primary,
            appBar: AppBar(title: const Text('Cart')),
            body: MarketBody(
              child: Center(
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      LucideIcons.shoppingCart,
                      size: 64,
                      color: context.colors.borderStrong,
                    ),
                    const SizedBox(height: Spacing.lg),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: FontSizeToken.xl,
                        fontWeight: .bold,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      'Add some products to get started!',
                      style: TextStyle(color: context.colors.textSubtle),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final groupedByMerchant = <String, List<CartItem>>{};
    for (final item in cartItems) {
      groupedByMerchant
          .putIfAbsent(item.product.merchantId, () => [])
          .add(item);
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Scaffold(
          backgroundColor: context.colors.primary,
          appBar: AppBar(title: const Text('Cart')),
          body: MarketBody(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(Spacing.lg),
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
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(top: BorderSide(color: context.colors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      mainAxisSize: .min,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: FontSizeToken.sm,
                            color: context.colors.textSubtle,
                          ),
                        ),
                        Text(
                          '৳$totalAmount',
                          style: const TextStyle(
                            fontSize: FontSizeToken.xxl,
                            fontWeight: .bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.push(AppRoute.marketplaceCheckout.path),

                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontWeight: .bold),
                        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.lg),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.md,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusToken.md),
                    border: Border.all(color: context.colors.border),
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
                                fit: .cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 28,
                                  height: 28,
                                  color: context.colors.surfaceAlt,
                                  child: Icon(
                                    LucideIcons.store,
                                    size: 16,
                                    color: context.colors.textSubtle,
                                  ),
                                ),
                              )
                            : Container(
                                width: 28,
                                height: 28,
                                color: context.colors.surfaceAlt,
                                child: Icon(
                                  LucideIcons.store,
                                  size: 16,
                                  color: context.colors.textSubtle,
                                ),
                              ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: Text(
                          merchantName,
                          style: const TextStyle(
                            fontWeight: .bold,
                            fontSize: FontSizeToken.base,
                          ),
                        ),
                      ),
                      if (!isPlatform)
                        Icon(
                          LucideIcons.chevronRight,
                          size: 16,
                          color: context.colors.textSubtle,
                        ),
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
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            child: SizedBox(
              width: 56,
              height: 56,
              child: item.product.imageUrls.isNotEmpty
                  ? Image.network(
                      item.product.imageUrls.first,
                      fit: .cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        LucideIcons.shoppingBag,
                        color: context.colors.borderStrong,
                      ),
                    )
                  : Icon(
                      LucideIcons.shoppingBag,
                      color: context.colors.borderStrong,
                    ),
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: const TextStyle(
                    fontWeight: .w600,
                    fontSize: FontSizeToken.md,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  '৳${item.product.price}',
                  style: const TextStyle(
                    fontWeight: .bold,
                    fontSize: FontSizeToken.md,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.minus, size: 18),
                onPressed: () => ref
                    .read(cartProvider.notifier)
                    .updateQuantity(item.product.id, item.quantity - 1),
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(fontWeight: .bold),
              ),
              IconButton(
                icon: const Icon(LucideIcons.plus, size: 18),
                onPressed: () => ref
                    .read(cartProvider.notifier)
                    .updateQuantity(item.product.id, item.quantity + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
