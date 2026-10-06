import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class MarketplaceHomeScreen extends ConsumerWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;
    final categoriesAsync = ref.watch(categoriesListProvider);

    if (user == null) return const Center(child: CupertinoActivityIndicator());

    final productsAsync = ref.watch(
      productsListProvider((
        universityId: user.university,
        departmentId: user.department,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Market'),
        actions: [
          IconButton(
            tooltip: 'Saved items',
            icon: const Icon(LucideIcons.heart),
            onPressed: () =>
                context.pushNamed(AppRoute.marketplaceWishlist.name),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
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
                const SliverToBoxAdapter(child: _HeroBanner()),
                const SliverToBoxAdapter(child: _TrustStrip()),

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
                          if (featured.isEmpty) return const SizedBox.shrink();
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
                      if (categories.isEmpty) return const SizedBox.shrink();
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
                      child: Center(child: CupertinoActivityIndicator()),
                    ),
                    error: (e, _) => const SizedBox.shrink(),
                  ),
                ),

                ...productsAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return [const SliverToBoxAdapter(child: _EmptyState())];
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
                        child: Center(child: CupertinoActivityIndicator()),
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
                            style: TextStyle(color: context.colors.textMuted),
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
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.sm, Spacing.lg, 0),
      child: GestureDetector(
        onTap: () => context.pushNamed(AppRoute.marketplaceSearch.name),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          decoration: BoxDecoration(
            color: c.surfaceAlt,
            borderRadius: BorderRadius.circular(RadiusToken.xxl),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.search, size: 18, color: c.textSubtle),
              const SizedBox(width: Spacing.md),
              Text(
                'Search books, gadgets, services…',
                style: TextStyle(
                  fontSize: FontSizeToken.base,
                  color: c.textSubtle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Hero ────────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusToken.xl),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c.primary, c.primaryPressed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Soft decorative rings
              Positioned(
                right: -36,
                top: -36,
                child: _Ring(
                  size: 150,
                  color: c.onPrimary.withValues(alpha: 0.08),
                ),
              ),
              Positioned(
                right: 24,
                bottom: -52,
                child: _Ring(
                  size: 110,
                  color: c.onPrimary.withValues(alpha: 0.06),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: c.onPrimary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(RadiusToken.full),
                      ),
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          Icon(
                            LucideIcons.sparkles,
                            size: 12,
                            color: c.onPrimary,
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            'CAMPUS EXCLUSIVE',
                            style: TextStyle(
                              fontSize: FontSizeToken.xxs,
                              fontWeight: .w700,
                              letterSpacing: 0.8,
                              color: c.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      'Shop smarter,\nright on campus.',
                      style: TextStyle(
                        fontSize: FontSizeToken.display,
                        height: 1.15,
                        fontWeight: .w800,
                        color: c.onPrimary,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      'Verified student sellers, secure bKash checkout and delivery to your campus.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: c.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    FilledButton.icon(
                      onPressed: () =>
                          context.pushNamed(AppRoute.marketplaceInfo.name),
                      icon: const Icon(LucideIcons.arrowRight, size: 14),
                      iconAlignment: IconAlignment.end,
                      label: const Text('How it works'),
                      style: FilledButton.styleFrom(
                        backgroundColor: c.onPrimary,
                        foregroundColor: c.primary,
                        textStyle: const TextStyle(
                          fontSize: FontSizeToken.sm,
                          fontWeight: .w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  final double size;
  final Color color;
  const _Ring({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

// ─── Trust strip ─────────────────────────────────────────────────────────

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    const items = [
      (LucideIcons.badgeCheck, 'Verified sellers'),
      (LucideIcons.shieldCheck, 'Secure payment'),
      (LucideIcons.truck, 'Campus delivery'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 0),
      child: Row(
        children: [
          for (final (icon, label) in items)
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: context.colors.primarySubtle,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 18, color: context.colors.primary),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: FontSizeToken.xs,
                      fontWeight: .w600,
                      color: context.colors.textMuted,
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
                  ? Image.network(
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
