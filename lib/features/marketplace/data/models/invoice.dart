class InvoiceLine {
  final String description;
  final int quantity;
  final int unitPrice;
  final int total;
  const InvoiceLine({required this.description, required this.quantity, required this.unitPrice, required this.total});

  factory InvoiceLine.fromJson(Map<String, dynamic> j) => InvoiceLine(
    description: j['description'] as String? ?? '',
    quantity: j['quantity'] as int? ?? 1,
    unitPrice: j['unit_price'] as int? ?? 0,
    total: j['total'] as int? ?? 0,
  );
}

/// A customer receipt for a completed payment (subscription or order).
class Invoice {
  final String id;
  final String number;
  final String kind; // subscription | order
  final int subtotal;
  final int discount;
  final int total;
  final String paymentMethod;
  final String paymentRef;
  final DateTime issuedAt;
  final bool voided; // refunded
  final List<InvoiceLine> lines;

  const Invoice({
    required this.id,
    required this.number,
    required this.kind,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.paymentRef,
    required this.issuedAt,
    required this.voided,
    required this.lines,
  });

  factory Invoice.fromJson(Map<String, dynamic> j) => Invoice(
    id: j['id'] as String? ?? '',
    number: j['number'] as String? ?? '',
    kind: j['kind'] as String? ?? '',
    subtotal: j['subtotal'] as int? ?? 0,
    discount: j['discount'] as int? ?? 0,
    total: j['total'] as int? ?? 0,
    paymentMethod: j['payment_method'] as String? ?? '',
    paymentRef: j['payment_ref'] as String? ?? '',
    issuedAt: DateTime.tryParse(j['issued_at'] as String? ?? '')?.toLocal() ?? DateTime.now(),
    voided: j['voided_at'] != null,
    lines: (j['lines'] as List? ?? []).map((e) => InvoiceLine.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
