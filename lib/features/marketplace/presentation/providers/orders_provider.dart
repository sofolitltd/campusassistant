import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../data/models/order.dart';

enum MarketplacePaymentMethod {
  bkash('bkash'),
  cashOnDelivery('cash_on_delivery');

  final String apiValue;
  const MarketplacePaymentMethod(this.apiValue);
}

final ordersListProvider = FutureProvider<List<Order>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/my/orders');
  final data = response.data as List;
  return data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
});

final orderDetailsProvider =
    FutureProvider.family<Order, String>((ref, orderId) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get('/my/orders/$orderId');
  return Order.fromJson(response.data as Map<String, dynamic>);
});

class CheckoutResult {
  final String orderId;
  final String bkashUrl;
  final String paymentId;
  final String successUrl;
  final String failureUrl;
  final String cancelUrl;

  CheckoutResult({
    required this.orderId,
    required this.bkashUrl,
    required this.paymentId,
    required this.successUrl,
    required this.failureUrl,
    required this.cancelUrl,
  });
}

Future<CheckoutResult> checkout(
  WidgetRef ref, {
  required String addressId,
  required List<Map<String, dynamic>> items,
  required MarketplacePaymentMethod paymentMethod,
}) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    '/my/orders/checkout',
    data: {
      'address_id': addressId,
      'items': items,
      'payment_method': paymentMethod.apiValue,
    },
  );
  final order = response.data as Map<String, dynamic>;
  return CheckoutResult(
    orderId: order['id'] as String,
    bkashUrl: '',
    paymentId: '',
    successUrl: '',
    failureUrl: '',
    cancelUrl: '',
  );
}

Future<Map<String, dynamic>> createMarketplacePayment(
    WidgetRef ref, String orderId) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post(
    '/payments/marketplace/create',
    data: {'order_id': orderId},
    // bKash's grant-token + create-payment round trip to their gateway can
    // run past the client's default 15s timeout; give it more room here
    // instead of relaxing the global timeout for every request.
    options: Options(
      sendTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
    ),
  );
  return response.data as Map<String, dynamic>;
}

Future<void> executeMarketplacePayment(
    WidgetRef ref, String paymentId) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.post(
    '/payments/marketplace/execute',
    data: {'payment_id': paymentId},
  );
}
