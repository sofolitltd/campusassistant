class Merchant {
  final String id;
  final String businessName;
  final String description;
  final String logoUrl;
  final String businessType;
  // Phone/email are admin/self-service only — the backend redacts them from
  // the public storefront lookup (GET /merchants/:id), so these will be
  // empty when viewing another merchant's public profile.
  final String phone;
  final String email;
  final double commissionRate;
  final String status; // pending | approved | rejected
  final bool isPlatform;
  final String? rejectionReason;

  Merchant({
    required this.id,
    required this.businessName,
    required this.description,
    required this.logoUrl,
    required this.businessType,
    required this.phone,
    required this.email,
    required this.commissionRate,
    required this.status,
    required this.isPlatform,
    this.rejectionReason,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'] as String,
      businessName: json['business_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      logoUrl: json['logo_url'] as String? ?? '',
      businessType: json['business_type'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      commissionRate: (json['commission_rate'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'pending',
      isPlatform: json['is_platform'] as bool? ?? false,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }
}
