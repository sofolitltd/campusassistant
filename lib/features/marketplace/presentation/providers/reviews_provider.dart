import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../data/models/review.dart';

final productReviewsProvider = FutureProvider.family<ProductReviews, String>((ref, productId) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/my/products/$productId/reviews', queryParameters: {'limit': 50});
  return ProductReviews.fromJson(response.data as Map<String, dynamic>);
});

/// Delivered-order lines and the buyer's rating for each.
final orderReviewableProvider = FutureProvider.family<List<ReviewableItem>, String>((ref, orderId) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/my/orders/$orderId/reviewable');
  final data = (response.data as Map<String, dynamic>)['data'] as List? ?? [];
  return data.map((e) => ReviewableItem.fromJson(e as Map<String, dynamic>)).toList();
});

/// Creates or edits the signed-in user's review, then refreshes what shows it.
Future<void> submitReview(
  WidgetRef ref, {
  required String productId,
  required int rating,
  required String comment,
}) async {
  final api = ref.read(apiClientProvider);
  await api.put('/my/products/$productId/review', data: {'rating': rating, 'comment': comment});
  ref.invalidate(productReviewsProvider(productId));
  ref.invalidate(orderReviewableProvider);
}

Future<void> deleteReview(WidgetRef ref, {required String productId}) async {
  final api = ref.read(apiClientProvider);
  await api.delete('/my/products/$productId/review');
  ref.invalidate(productReviewsProvider(productId));
  ref.invalidate(orderReviewableProvider);
}
