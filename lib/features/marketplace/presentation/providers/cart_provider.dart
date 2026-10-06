import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/core/di.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';

/// The shopping cart. Kept per signed-in user and saved on the device so it
/// survives closing the app; on load every line is revalidated against the
/// server (still on sale, current price, enough stock).
class CartNotifier extends Notifier<List<CartItem>> {
  static const _storage = FlutterSecureStorage();
  String? _key;

  @override
  List<CartItem> build() {
    // Rebuild only when the signed-in user changes, not on every profile refresh.
    final uid = ref.watch(userProvider.select((u) => u.value?.uid));
    _key = uid == null ? null : 'marketplace_cart_$uid';
    if (_key != null) _restore(_key!);
    return [];
  }

  Future<void> _restore(String key) async {
    try {
      final raw = await _storage.read(key: key);
      if (raw == null || raw.isEmpty) return;
      final saved = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      if (saved.isEmpty) return;

      final ids = saved.map((e) => e['id'] as String).join(',');
      final response = await ref
          .read(apiClientProvider)
          .get('/products-lookup', queryParameters: {'ids': ids});
      final fresh = {
        for (final p
            in ((response.data as Map<String, dynamic>)['data'] as List? ?? []))
          (p as Map<String, dynamic>)['id'] as String: Product.fromJson(p),
      };

      // Anything added while we were loading wins over the saved copy.
      final inCart = {for (final item in state) item.product.id};
      final restored = <CartItem>[];
      for (final line in saved) {
        final product = fresh[line['id']];
        if (product == null ||
            product.stock <= 0 ||
            inCart.contains(product.id)) {
          continue;
        }
        final want = (line['q'] as num?)?.toInt() ?? 1;
        restored.add(
          CartItem(
            product: product,
            quantity: want > product.stock ? product.stock : want,
          ),
        );
      }
      if (!ref.mounted || _key != key) return;
      state = [...restored, ...state];
      await _persist();
    } catch (_) {
      // A cart that can't be restored is just an empty cart.
    }
  }

  Future<void> _persist() async {
    final key = _key;
    if (key == null) return;
    try {
      await _storage.write(
        key: key,
        value: jsonEncode([
          for (final i in state) {'id': i.product.id, 'q': i.quantity},
        ]),
      );
    } catch (_) {}
  }

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            CartItem(
              product: state[i].product,
              quantity: state[i].quantity + quantity,
            )
          else
            state[i],
      ];
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
    _persist();
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
    _persist();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    state = [
      for (final item in state)
        if (item.product.id == productId)
          CartItem(product: item.product, quantity: quantity)
        else
          item,
    ];
    _persist();
  }

  void clear() {
    state = [];
    _persist();
  }

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);

  int get totalAmount => state.fold(0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);
