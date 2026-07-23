import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  int get totalPrice => product.price * quantity;
}
