import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '../../data/models/review.dart';
import '../../data/models/seller_models.dart';

typedef StatsKey = ({String merchantId, int days});

final merchantStatsProvider = FutureProvider.family<MerchantStats, StatsKey>((ref, key) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/my/merchants/${key.merchantId}/stats', queryParameters: {'days': key.days});
  return MerchantStats.fromJson(response.data as Map<String, dynamic>);
});

final merchantEarningsProvider = FutureProvider.family<Earnings, String>((ref, merchantId) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/my/merchants/$merchantId/earnings');
  return Earnings.fromJson(response.data as Map<String, dynamic>);
});

final merchantPayoutsProvider = FutureProvider.family<List<Payout>, String>((ref, merchantId) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/my/merchants/$merchantId/payouts', queryParameters: {'limit': 50});
  final list = (response.data as Map<String, dynamic>)['payouts'] as List? ?? [];
  return list.map((e) => Payout.fromJson(e as Map<String, dynamic>)).toList();
});

/// Reviews on a seller's products, newest first.
final merchantReviewsProvider = FutureProvider.family<List<Review>, String>((ref, merchantId) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/my/merchants/$merchantId/reviews', queryParameters: {'limit': 50});
  final list = (response.data as Map<String, dynamic>)['reviews'] as List? ?? [];
  return list.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
});

/// Pulls the server's message out of a failed request, or falls back.
String apiErrorMessage(Object error, {String fallback = 'Something went wrong. Please try again.'}) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['error'] is String) return data['error'] as String;
  }
  return fallback;
}

Future<void> requestPayout(WidgetRef ref, {required String merchantId, required int amount}) async {
  final api = ref.read(apiClientProvider);
  await api.post('/my/merchants/$merchantId/payouts', data: {'amount': amount});
  ref.invalidate(merchantEarningsProvider(merchantId));
  ref.invalidate(merchantPayoutsProvider(merchantId));
}

Future<void> replyToReview(
  WidgetRef ref, {
  required String merchantId,
  required String reviewId,
  required String reply,
}) async {
  final api = ref.read(apiClientProvider);
  await api.post('/my/merchants/$merchantId/reviews/$reviewId/reply', data: {'reply': reply});
  ref.invalidate(merchantReviewsProvider(merchantId));
}

/// Counts one product-page open (fire and forget; errors are irrelevant).
Future<void> recordProductView(WidgetRef ref, String productId) async {
  try {
    await ref.read(apiClientProvider).post('/my/products/$productId/view');
  } catch (_) {}
}

/// What fee a seller pays right now, and whether a new-seller promo is running.
class CommissionInfo {
  final double rate;
  final double baseRate;
  final bool onPromo;
  final int promoDaysLeft;
  const CommissionInfo({required this.rate, required this.baseRate, required this.onPromo, required this.promoDaysLeft});

  factory CommissionInfo.fromJson(Map<String, dynamic> j) => CommissionInfo(
    rate: (j['rate'] as num?)?.toDouble() ?? 0,
    baseRate: (j['base_rate'] as num?)?.toDouble() ?? 0,
    onPromo: j['on_promo'] as bool? ?? false,
    promoDaysLeft: j['promo_days_left'] as int? ?? 0,
  );
}

final merchantCommissionProvider = FutureProvider.family<CommissionInfo, String>((ref, merchantId) async {
  final response = await ref.watch(apiClientProvider).get('/my/merchants/$merchantId/commission');
  return CommissionInfo.fromJson(response.data as Map<String, dynamic>);
});

/// The running new-seller promotion, if any (public: used to invite people to sell).
class SellerPromo {
  final bool active;
  final double rate;
  final int days;
  const SellerPromo({required this.active, required this.rate, required this.days});
}

final sellerPromoProvider = FutureProvider<SellerPromo>((ref) async {
  try {
    final response = await ref.watch(apiClientProvider).get('/marketplace/promo');
    final j = response.data as Map<String, dynamic>;
    return SellerPromo(
      active: j['active'] as bool? ?? false,
      rate: (j['rate'] as num?)?.toDouble() ?? 0,
      days: j['days'] as int? ?? 0,
    );
  } catch (_) {
    return const SellerPromo(active: false, rate: 0, days: 0);
  }
});

String formatPercent(double v) => v == v.roundToDouble() ? '${v.round()}%' : '${v.toStringAsFixed(1)}%';
