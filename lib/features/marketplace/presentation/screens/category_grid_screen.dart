import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_radius.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/category.dart';
import '../providers/marketplace_provider.dart';

class CategoryGridScreen extends ConsumerWidget {
  const CategoryGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesListProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(child: Text('No categories yet.'));
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, i) => _CategoryCard(category: categories[i]),
          ),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (e, _) => Center(child: Text('Could not load categories: $e')),
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  final Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;

    return GestureDetector(
      onTap: () {
        if (user != null) {
          context.push(
            '/marketplace/category/${category.id}',
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
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  category.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(LucideIcons.layers, size: 32, color: Colors.grey.shade400),
                ),
              )
            else
              Icon(LucideIcons.layers, size: 32, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
