import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme/app_colors.dart';
import '../providers/marketplace_provider.dart';
import 'product_detail_screen.dart';

/// Opens a product when only its id is known (e.g. from a back-in-stock push).
class ProductDetailLoader extends ConsumerWidget {
  final String productId;
  const ProductDetailLoader({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(productDetailsProvider(productId)).when(
      data: (product) => ProductDetailScreen(product: product),
      loading: () => const Scaffold(body: Center(child: CupertinoActivityIndicator())),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('This product is no longer available.', style: TextStyle(color: context.colors.textMuted))),
      ),
    );
  }
}
