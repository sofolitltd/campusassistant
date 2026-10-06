import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/category.dart';
import '../providers/marketplace_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '../widgets/market_theme.dart';

class CategoryGridScreen extends ConsumerWidget {
  const CategoryGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesListProvider);

    return Scaffold(
      backgroundColor: context.colors.primary,
      appBar: AppBar(title: const Text('Categories')),
      body: MarketBody(
        child: categoriesAsync.when(
          data: (categories) {
            if (categories.isEmpty) {
              return const Center(child: Text('No categories yet.'));
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.lg,
                      Spacing.xl,
                      Spacing.lg,
                      Spacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Browse by category',
                          style: TextStyle(
                            fontSize: FontSizeToken.xl,
                            fontWeight: FontWeight.w800,
                            color: context.colors.text,
                          ),
                        ),
                        const SizedBox(height: Spacing.xxs),
                        Text(
                          '${categories.length} categories on campus',
                          style: TextStyle(
                            fontSize: FontSizeToken.sm,
                            color: context.colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    0,
                    Spacing.lg,
                    Spacing.xxxl,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _CategoryCard(category: categories[i]),
                      childCount: categories.length,
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text('Could not load categories: $e')),
        ),
      ),
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  final Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;
    final c = context.colors;

    return GestureDetector(
      onTap: () {
        if (user != null) {
          context.push(
            '/campusmarket/category/${category.id}',
            extra: {
              'category': category,
              'universityId': user.university,
              'departmentId': user.department,
            },
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusToken.xl),
          boxShadow: [
            BoxShadow(
              color: c.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RadiusToken.xl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Backdrop: photo, or a soft tinted tile with a large glyph.
              ColoredBox(color: c.primarySubtle),
              Positioned(
                right: -14,
                top: -10,
                child: Icon(
                  LucideIcons.layers,
                  size: 84,
                  color: c.primary.withValues(alpha: 0.14),
                ),
              ),
              if (category.imageUrl.isNotEmpty)
                Image.network(
                  ApiEndpoints.resolveImageUrl(category.imageUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              // Scrim so the label stays readable on any photo.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.45, 1],
                    colors: [
                      c.scrim.withValues(alpha: 0),
                      c.scrim.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: Spacing.md,
                right: Spacing.md,
                bottom: Spacing.md,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: FontSizeToken.md,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: c.onScrim,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: c.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.arrowRight,
                        size: 14,
                        color: c.onPrimary,
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
