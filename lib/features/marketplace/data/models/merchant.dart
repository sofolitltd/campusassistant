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
  final String? website;
  final String? socialMediaLink;
  // Verification documents — admin/self-service only, same visibility rule
  // as phone/email: redacted from the public storefront lookup.
  final String? studentIdProofUrl;
  final String? nidProofUrl;
  // Where commission-adjusted revenue is paid out — distinct from
  // phone/email, which are just contact details. Same admin/self-service
  // only visibility.
  final String? payoutMethod; // "bkash" | "nagad" | "bank"
  final String? payoutAccount;

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
    this.website,
    this.socialMediaLink,
    this.studentIdProofUrl,
    this.nidProofUrl,
    this.payoutMethod,
    this.payoutAccount,
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
      website: json['website'] as String?,
      socialMediaLink: json['social_media_link'] as String?,
      studentIdProofUrl: json['student_id_proof_url'] as String?,
      nidProofUrl: json['nid_proof_url'] as String?,
      payoutMethod: json['payout_method'] as String?,
      payoutAccount: json['payout_account'] as String?,
    );
  }
}
