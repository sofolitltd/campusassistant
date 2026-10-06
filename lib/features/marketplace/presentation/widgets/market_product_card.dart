import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '../../data/models/product.dart';
import '../providers/cart_provider.dart';
import 'rating_widgets.dart';
import 'wishlist_button.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// The marketplace product card used by the home, search and wishlist screens:
/// photo with stock badge and save heart, seller (with trust marks), rating,
/// price and a quick add-to-cart button.
class MarketProductCard extends ConsumerWidget {
  final Product product;
  final double imageHeight;
  const MarketProductCard({super.key, required this.product, this.imageHeight = 156});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final imageUrl = product.imageUrls.isNotEmpty ? product.imageUrls.first : '';
    final soldOut = product.stock <= 0;
    final lowStock = !soldOut && product.stock <= 5;
    final merchant = product.merchant;

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoute.marketplaceProductDetails.name,
        pathParameters: {'productId': product.id},
        extra: product,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(RadiusToken.xl),
          border: Border.all(color: c.border),
          boxShadow: [
            BoxShadow(
              color: c.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(RadiusToken.xl),
              ),
              child: SizedBox(
                width: double.infinity,
                height: imageHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                            ApiEndpoints.resolveImageUrl(imageUrl),
                            fit: .cover,
                            errorBuilder: (_, _, _) => _ImagePlaceholder(c: c),
                          )
                        : _ImagePlaceholder(c: c),
                    if (soldOut)
                      Container(
                        color: c.surface.withValues(alpha: 0.6),
                        alignment: Alignment.center,
                        child: _Badge(
                          label: 'Sold out',
                          bg: c.surfaceInverse,
                          fg: c.textInverse,
                        ),
                      )
                    else if (lowStock)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: _Badge(
                          label: 'Only ${product.stock} left',
                          bg: c.warningSubtle,
                          fg: c.warning,
                        ),
                      ),
                    if (product.isFeatured && !soldOut)
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: _Badge(label: '★ Featured', bg: c.primary, fg: c.onPrimary),
                      ),
                    Positioned(right: 6, top: 6, child: WishlistButton(productId: product.id, overlay: true, size: 16)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.md, Spacing.md, Spacing.sm, Spacing.md),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  if (merchant != null) ...[
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            merchant.businessName,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: .w600,
                              color: c.textSubtle,
                            ),
                          ),
                        ),
                        if (merchant.isPlatform || merchant.status == 'approved') ...[
                          const SizedBox(width: Spacing.xs),
                          Icon(LucideIcons.badgeCheck, size: 12, color: c.primary),
                        ],
                        if (merchant.isFastShipper) ...[
                          const SizedBox(width: Spacing.xs),
                          Icon(LucideIcons.zap, size: 12, color: c.warning),
                        ],
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                  ],
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: TextStyle(
                      fontWeight: .w600,
                      fontSize: FontSizeToken.md,
                      height: 1.25,
                      color: c.text,
                    ),
                  ),
                  if (product.ratingCount > 0) ...[
                    const SizedBox(height: Spacing.xs),
                    RatingBadge(average: product.ratingAvg, count: product.ratingCount),
                  ],
                  const SizedBox(height: Spacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '৳${product.price}',
                          style: TextStyle(
                            fontWeight: .w800,
                            fontSize: FontSizeToken.lg,
                            color: c.primary,
                          ),
                        ),
                      ),
                      if (!soldOut)
                        _AddButton(
                          onTap: () {
                            ref.read(cartProvider.notifier).addItem(product);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text('Added "${product.title}" to cart'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(right: Spacing.xxs),
      child: Material(
        color: c.primary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(LucideIcons.plus, size: 16, color: c.onPrimary),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(RadiusToken.full),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: FontSizeToken.xxs, fontWeight: .w700, color: fg),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final AppColors c;
  const _ImagePlaceholder({required this.c});

  @override
  Widget build(BuildContext context) => Container(
    color: c.surfaceAlt,
    child: Icon(LucideIcons.shoppingBag, color: c.textSubtle),
  );
}
