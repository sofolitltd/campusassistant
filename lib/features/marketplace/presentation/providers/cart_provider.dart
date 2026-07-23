import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            CartItem(product: state[i].product, quantity: state[i].quantity + quantity)
          else
            state[i],
      ];
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
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
  }

  void clear() => state = [];

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);

  int get totalAmount => state.fold(0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);
