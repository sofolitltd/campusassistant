/// Seller-side models: analytics, earnings and payouts.
class DailyPoint {
  final String date;
  final int orders;
  final int revenue;
  const DailyPoint({required this.date, required this.orders, required this.revenue});

  factory DailyPoint.fromJson(Map<String, dynamic> j) => DailyPoint(
    date: j['date'] as String? ?? '',
    orders: j['orders'] as int? ?? 0,
    revenue: j['revenue'] as int? ?? 0,
  );
}

class TopProduct {
  final String productId;
  final String title;
  final int units;
  final int revenue;
  final int views;
  const TopProduct({
    required this.productId,
    required this.title,
    required this.units,
    required this.revenue,
    required this.views,
  });

  factory TopProduct.fromJson(Map<String, dynamic> j) => TopProduct(
    productId: j['product_id'] as String? ?? '',
    title: j['title'] as String? ?? '',
    units: j['units'] as int? ?? 0,
    revenue: j['revenue'] as int? ?? 0,
    views: j['views'] as int? ?? 0,
  );
}

class MerchantStats {
  final int days;
  final int orders;
  final int deliveredOrders;
  final int units;
  final int grossRevenue;
  final int netRevenue;
  final int views;
  final int avgOrderValue;
  final double ratingAvg;
  final int ratingCount;
  final double avgShipHours;
  final int shippedCount;
  final int lowStockProducts;
  final List<DailyPoint> daily;
  final List<TopProduct> topProducts;

  const MerchantStats({
    required this.days,
    required this.orders,
    required this.deliveredOrders,
    required this.units,
    required this.grossRevenue,
    required this.netRevenue,
    required this.views,
    required this.avgOrderValue,
    required this.ratingAvg,
    required this.ratingCount,
    required this.avgShipHours,
    required this.shippedCount,
    required this.lowStockProducts,
    required this.daily,
    required this.topProducts,
  });

  factory MerchantStats.fromJson(Map<String, dynamic> j) => MerchantStats(
    days: j['days'] as int? ?? 30,
    orders: j['orders'] as int? ?? 0,
    deliveredOrders: j['delivered_orders'] as int? ?? 0,
    units: j['units'] as int? ?? 0,
    grossRevenue: j['gross_revenue'] as int? ?? 0,
    netRevenue: j['net_revenue'] as int? ?? 0,
    views: j['views'] as int? ?? 0,
    avgOrderValue: j['avg_order_value'] as int? ?? 0,
    ratingAvg: (j['rating_avg'] as num?)?.toDouble() ?? 0,
    ratingCount: j['rating_count'] as int? ?? 0,
    avgShipHours: (j['avg_ship_hours'] as num?)?.toDouble() ?? 0,
    shippedCount: j['shipped_count'] as int? ?? 0,
    lowStockProducts: j['low_stock_products'] as int? ?? 0,
    daily: (j['daily'] as List? ?? []).map((e) => DailyPoint.fromJson(e as Map<String, dynamic>)).toList(),
    topProducts: (j['top_products'] as List? ?? []).map((e) => TopProduct.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

class Earnings {
  final int balance;
  final int minPayout;
  final bool hasPayoutAccount;
  const Earnings({required this.balance, required this.minPayout, required this.hasPayoutAccount});

  factory Earnings.fromJson(Map<String, dynamic> j) => Earnings(
    balance: j['balance'] as int? ?? 0,
    minPayout: j['min_payout'] as int? ?? 0,
    hasPayoutAccount: j['has_payout_account'] as bool? ?? false,
  );
}

class Payout {
  final String id;
  final int amount;
  final String status; // requested | paid | rejected
  final String method;
  final String account;
  final String reference;
  final String note;
  final DateTime createdAt;

  const Payout({
    required this.id,
    required this.amount,
    required this.status,
    required this.method,
    required this.account,
    required this.reference,
    required this.note,
    required this.createdAt,
  });

  factory Payout.fromJson(Map<String, dynamic> j) => Payout(
    id: j['id'] as String? ?? '',
    amount: j['amount'] as int? ?? 0,
    status: j['status'] as String? ?? 'requested',
    method: j['method'] as String? ?? '',
    account: j['account'] as String? ?? '',
    reference: j['reference'] as String? ?? '',
    note: j['note'] as String? ?? '',
    createdAt: DateTime.tryParse(j['created_at'] as String? ?? '')?.toLocal() ?? DateTime.now(),
  );
}

