import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

class CategoryGridScreen extends ConsumerWidget {
  const CategoryGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories yet.'));
          }
          return Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 640
                    ? 4
                    : width >= 480
                    ? 3
                    : 2;
                return MasonryGridView.builder(
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, i) =>
                      _CategoryCard(category: categories[i]),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Could not load categories: $e')),
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: .center,
          mainAxisAlignment: .center,
          children: [
            if (category.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(RadiusToken.md),
                child: Image.network(
                  ApiEndpoints.resolveImageUrl(category.imageUrl),
                  width: 48,
                  height: 48,
                  fit: .cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    LucideIcons.layers,
                    size: 32,
                    color: context.colors.textSubtle,
                  ),
                ),
              )
            else
              Icon(
                LucideIcons.layers,
                size: 32,
                color: context.colors.textSubtle,
              ),
            const SizedBox(height: Spacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: Text(
                category.name,
                maxLines: 1,
                overflow: .ellipsis,
                style: const TextStyle(
                  fontWeight: .w600,
                  fontSize: FontSizeToken.md,
                ),
                textAlign: .center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
