class BkashTransaction {
  final String id;
  final String planTitle;
  final int amount;
  final String status;
  final String trxId;
  final DateTime createdAt;

  BkashTransaction({
    required this.id,
    required this.planTitle,
    required this.amount,
    required this.status,
    required this.trxId,
    required this.createdAt,
  });

  factory BkashTransaction.fromJson(Map<String, dynamic> json) {
    return BkashTransaction(
      id: json['id'] as String,
      planTitle: (json['plan'] as Map<String, dynamic>?)?['title'] as String? ??
          'Subscription',
      amount: json['amount'] as int,
      status: json['status'] as String,
      trxId: json['trx_id'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
