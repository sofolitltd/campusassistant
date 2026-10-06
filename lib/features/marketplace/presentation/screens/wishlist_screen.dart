import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/market_product_card.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final async = ref.watch(wishlistProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved items')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: async.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (_, _) => Center(child: Text('Could not load your saved items.', style: TextStyle(color: c.textSubtle))),
            data: (products) {
              if (products.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.xxxl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.heart, size: 44, color: c.borderStrong),
                        const SizedBox(height: Spacing.md),
                        Text('Nothing saved yet', style: TextStyle(fontSize: FontSizeToken.xl, fontWeight: FontWeight.w800, color: c.text)),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          'Tap the heart on any product to keep it here. We will tell you when it is back in stock or gets cheaper.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: c.textMuted, fontSize: 12.5, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(wishlistProductsProvider);
                  await ref.read(wishlistProductsProvider.future);
                },
                child: MasonryGridView.extent(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Spacing.lg),
                  maxCrossAxisExtent: 180,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: products.length,
                  itemBuilder: (context, i) => MarketProductCard(product: products[i]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
