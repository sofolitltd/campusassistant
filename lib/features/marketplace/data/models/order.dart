class Order {
  final String id;
  final String status;
  final String paymentMethod;
  final int totalAmount;
  final String shippingRecipientName;
  final String shippingPhone;
  final String shippingAddressLine;
  final String shippingCity;
  final List<OrderItem> items;
  final String createdAt;

  Order({
    required this.id,
    required this.status,
    required this.paymentMethod,
    required this.totalAmount,
    required this.shippingRecipientName,
    required this.shippingPhone,
    required this.shippingAddressLine,
    required this.shippingCity,
    required this.items,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List? ?? [];
    return Order(
      id: json['id'] as String,
      status: json['status'] as String? ?? 'pending_payment',
      paymentMethod: json['payment_method'] as String? ?? 'bkash',
      totalAmount: json['total_amount'] as int? ?? 0,
      shippingRecipientName: json['shipping_recipient_name'] as String? ?? '',
      shippingPhone: json['shipping_phone'] as String? ?? '',
      shippingAddressLine: json['shipping_address_line'] as String? ?? '',
      shippingCity: json['shipping_city'] as String? ?? '',
      items: itemsJson.map((e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList(),
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}

class OrderItem {
  final String id;
  final String productTitle;
  final String productId;
  final String merchantId;
  final int quantity;
  final int unitPrice;

  OrderItem({
    required this.id,
    required this.productTitle,
    required this.productId,
    required this.merchantId,
    required this.quantity,
    required this.unitPrice,
  });

  int get totalPrice => unitPrice * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String? ?? '',
      productTitle: json['product_title'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      merchantId: json['merchant_id'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: json['unit_price'] as int? ?? 0,
    );
  }
}
