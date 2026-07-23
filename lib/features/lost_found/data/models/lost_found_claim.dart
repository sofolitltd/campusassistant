import 'lost_found_user.dart';

enum LostFoundClaimStatus { pending, accepted, rejected }

LostFoundClaimStatus lostFoundClaimStatusFromString(String? value) {
  switch (value) {
    case 'accepted':
      return LostFoundClaimStatus.accepted;
    case 'rejected':
      return LostFoundClaimStatus.rejected;
    default:
      return LostFoundClaimStatus.pending;
  }
}

class LostFoundClaim {
  final String id;
  final String itemId;
  final String claimerId;
  final LostFoundUser? claimer;
  final String message;
  final LostFoundClaimStatus status;
  final DateTime createdAt;

  LostFoundClaim({
    required this.id,
    required this.itemId,
    required this.claimerId,
    this.claimer,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  factory LostFoundClaim.fromJson(Map<String, dynamic> json) {
    final claimerJson = json['claimer'] as Map<String, dynamic>?;
    return LostFoundClaim(
      id: json['id'] as String? ?? '',
      itemId: json['item_id'] as String? ?? '',
      claimerId: json['claimer_id'] as String? ?? '',
      claimer: claimerJson != null && (claimerJson['id'] as String?)?.isNotEmpty == true
          ? LostFoundUser.fromJson(claimerJson)
          : null,
      message: json['message'] as String? ?? '',
      status: lostFoundClaimStatusFromString(json['status'] as String?),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
