import 'package:material_ui/material_ui.dart' hide CarouselView;
import 'package:flutter/material.dart' show CarouselView;

import '/core/widgets/app_loader.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/routes/app_route.dart';
import '../../data/models/category.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/market_product_card.dart';
import '../widgets/market_theme.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import '/core/theme/tokens/app_layout.dart';
import '/core/widgets/app_network_image.dart';

class MarketplaceHomeScreen extends ConsumerWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;
    final categoriesAsync = ref.watch(categoriesListProvider);

    if (user == null) return const Center(child: AppLoader());

    final productsAsync = ref.watch(
      productsListProvider((
        universityId: user.university,
        departmentId: user.department,
      )),
    );

    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Campus Market'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: 'Saved items',
              icon: const Icon(LucideIcons.heart),
              onPressed: () =>
                  context.pushNamed(AppRoute.marketplaceWishlist.name),
            ),
          ],
        ),
        body: MarketBody(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppLayout.pageWidth),
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(categoriesListProvider);
                  ref.invalidate(featuredProductsProvider);
                  ref.invalidate(productsListProvider);
                  await ref.read(
                    productsListProvider((
                      universityId: user.university,
                      departmentId: user.department,
                    )).future,
                  );
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: _SearchBar()),
                    const SliverToBoxAdapter(child: _MarketCarousel()),

                    // Featured
                    SliverToBoxAdapter(
                      child: ref
                          .watch(
                            featuredProductsProvider((
                              universityId: user.university,
                              departmentId: user.department,
                            )),
                          )
                          .maybeWhen(
                            data: (featured) {
                              if (featured.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _SectionHeader(
                                    title: 'Featured',
                                    subtitle: 'Hand-picked on campus',
                                  ),
                                  SizedBox(
                                    height: 236,
                                    child: ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: featured.length,
                                      separatorBuilder: (_, _) =>
                                          const SizedBox(width: 12),
                                      itemBuilder: (context, i) => SizedBox(
                                        width: 156,
                                        child: MarketProductCard(
                                          product: featured[i],
                                          imageHeight: 132,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            orElse: () => const SizedBox.shrink(),
                          ),
                    ),

                    // Categories
                    SliverToBoxAdapter(
                      child: categoriesAsync.when(
                        data: (categories) {
                          if (categories.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: .start,
                            children: [
                              const _SectionHeader(title: 'Shop by category'),
                              SizedBox(
                                height: 92,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.lg,
                                  ),
                                  scrollDirection: .horizontal,
                                  itemCount: categories.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: Spacing.lg),
                                  itemBuilder: (context, i) => _CategoryItem(
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
                        loading: () => const SizedBox(
                          height: 92,
                          child: Center(child: AppLoader()),
                        ),
                        error: (e, _) => const SizedBox.shrink(),
                      ),
                    ),

                    ...productsAsync.when(
                      data: (products) {
                        if (products.isEmpty) {
                          return [
                            const SliverToBoxAdapter(child: _EmptyState()),
                          ];
                        }
                        final fresh = products.take(8).toList();
                        return [
                          if (products.length > 3) ...[
                            const SliverToBoxAdapter(
                              child: _SectionHeader(
                                title: 'Just added',
                                subtitle: 'Fresh listings from campus sellers',
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 236,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.lg,
                                  ),
                                  scrollDirection: .horizontal,
                                  itemCount: fresh.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: Spacing.md),
                                  itemBuilder: (context, i) => SizedBox(
                                    width: 156,
                                    child: MarketProductCard(
                                      product: fresh[i],
                                      imageHeight: 132,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          SliverToBoxAdapter(
                            child: _SectionHeader(
                              title: 'All products',
                              subtitle: '${products.length} items on campus',
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                              Spacing.lg,
                              0,
                              Spacing.lg,
                              Spacing.xxxl,
                            ),
                            sliver: SliverMasonryGrid.extent(
                              maxCrossAxisExtent: 180,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childCount: products.length,
                              itemBuilder: (context, i) =>
                                  MarketProductCard(product: products[i]),
                            ),
                          ),
                        ];
                      },
                      loading: () => [
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 200,
                            child: Center(child: AppLoader()),
                          ),
                        ),
                      ],
                      error: (e, _) => [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                'Could not load products.',
                                style: TextStyle(
                                  color: context.colors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

// ─── Search ──────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 0),
      child: GestureDetector(
        onTap: () => context.pushNamed(AppRoute.marketplaceSearch.name),
        child: Container(
          height: 50,
          padding: const EdgeInsets.only(left: Spacing.lg, right: 5),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(RadiusToken.full),
            border: Border.all(color: c.primary.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: c.shadow,
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Search books, gadgets, services…',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: FontSizeToken.base,
                    color: c.textSubtle,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.search, size: 18, color: c.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketCarousel extends StatelessWidget {
  const _MarketCarousel();

  @override
  Widget build(BuildContext context) {
    const slides = [
      (
        LucideIcons.bookOpen,
        'Books, gadgets & more',
        'Find everyday essentials for campus life.',
      ),
      (
        LucideIcons.sparkles,
        'Discover something new',
        'Explore fresh listings from your campus community.',
      ),
      (
        LucideIcons.shoppingBag,
        'Your campus marketplace',
        'Browse products and find your next favorite.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: Spacing.lg, top: Spacing.lg),
      child: SizedBox(
        height: 148,
        child: CarouselView(
          itemExtent: 320,
          shrinkExtent: 280,
          itemSnapping: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusToken.md),
          ),
          children: [
            for (final (icon, title, subtitle) in slides)
              _MarketCarouselCard(icon: icon, title: title, subtitle: subtitle),
          ],
        ),
      ),
    );
  }
}

class _MarketCarouselCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MarketCarouselCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primaryPressed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.onPrimary.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: colors.onPrimary),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .start,
              children: [
                Text(
                  'CAMPUS MARKET',
                  style: TextStyle(
                    color: colors.onPrimary.withValues(alpha: 0.8),
                    fontSize: FontSizeToken.xxs,
                    fontWeight: .w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  title,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: FontSizeToken.lg,
                    fontWeight: .w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: TextStyle(
                    color: colors.onPrimary.withValues(alpha: 0.85),
                    fontSize: FontSizeToken.xs,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section header ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.xxl,
        Spacing.lg,
        Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: FontSizeToken.xl,
              fontWeight: .w800,
              color: context.colors.text,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: Spacing.xxs),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: FontSizeToken.sm,
                color: context.colors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Category ────────────────────────────────────────────────────────────

class _CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  const _CategoryItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: c.primarySubtle,
                shape: BoxShape.circle,
                border: Border.all(color: c.border),
              ),
              clipBehavior: .antiAlias,
              child: category.imageUrl.isNotEmpty
                  ? AppNetworkImage(
                      ApiEndpoints.resolveImageUrl(category.imageUrl),
                      fit: .cover,
                      errorBuilder: (_, _, _) =>
                          Icon(LucideIcons.layers, size: 22, color: c.primary),
                    )
                  : Icon(LucideIcons.layers, size: 22, color: c.primary),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              category.name,
              maxLines: 1,
              overflow: .ellipsis,
              style: TextStyle(
                fontSize: FontSizeToken.xs,
                fontWeight: .w600,
                color: c.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: c.primarySubtle,
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.store, size: 28, color: c.primary),
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            'No products yet',
            style: TextStyle(
              fontSize: FontSizeToken.lg,
              fontWeight: .w700,
              color: c.text,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            'New listings from campus sellers will show up here.',
            textAlign: .center,
            style: TextStyle(fontSize: 12.5, color: c.textMuted),
          ),
        ],
      ),
    );
  }
}
