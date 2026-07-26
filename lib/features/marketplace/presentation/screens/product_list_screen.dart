import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/category.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/product_grid_card.dart';

class ProductListScreen extends ConsumerWidget {
  final String? categoryId;
  final Category? category;

  const ProductListScreen({super.key, this.categoryId, this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;

    if (user == null) return const Center(child: CupertinoActivityIndicator());

    final productsAsync = ref.watch(
      categoryId != null
          ? productsListByCategoryProvider((
              universityId: user.university,
              departmentId: user.department,
              categoryId: categoryId!,
            ))
          : productsListProvider((
              universityId: user.university,
              departmentId: user.department,
            )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? 'Products'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products in this category.'));
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 640 ? 4 : width >= 480 ? 3 : 2;
              return MasonryGridView.builder(
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                ),
                itemCount: products.length,
                itemBuilder: (context, i) => ProductGridCard(product: products[i]),
              );
            },
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Could not load products.')),
      ),
        ),
      ),
    );
  }
}
