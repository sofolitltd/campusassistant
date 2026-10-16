import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';

/// The signed-in user's invite code and stats (`GET /my/referral`). The code
/// is issued by the backend on first request.
class ReferralSummary {
  const ReferralSummary({
    required this.code,
    required this.invitedCount,
    required this.verifiedCount,
    required this.pointsEarned,
    required this.referrerReward,
    required this.refereeReward,
    required this.hasReferrer,
    required this.canApplyCode,
  });

  final String code;
  final int invitedCount;
  final int verifiedCount;
  final int pointsEarned;
  final int referrerReward;
  final int refereeReward;
  final bool hasReferrer;
  final bool canApplyCode;

  factory ReferralSummary.fromJson(Map<String, dynamic> json) {
    return ReferralSummary(
      code: json['code'] as String? ?? '',
      invitedCount: (json['invited_count'] as num?)?.toInt() ?? 0,
      verifiedCount: (json['verified_count'] as num?)?.toInt() ?? 0,
      pointsEarned: (json['points_earned'] as num?)?.toInt() ?? 0,
      referrerReward: (json['referrer_reward'] as num?)?.toInt() ?? 0,
      refereeReward: (json['referee_reward'] as num?)?.toInt() ?? 0,
      hasReferrer: json['has_referrer'] as bool? ?? false,
      canApplyCode: json['can_apply_code'] as bool? ?? false,
    );
  }
}

final referralSummaryProvider = FutureProvider.autoDispose<ReferralSummary>((
  ref,
) async {
  final response = await ref.watch(apiClientProvider).get('/my/referral');
  return ReferralSummary.fromJson(response.data as Map<String, dynamic>);
});

/// Applies a friend's code to the current account. Returns null on success,
/// or a user-facing error message.
Future<String?> applyReferralCode(WidgetRef ref, String code) async {
  try {
    await ref
        .read(apiClientProvider)
        .post('/my/referral/apply', data: {'code': code.trim().toUpperCase()});
    ref.invalidate(referralSummaryProvider);
    return null;
  } on DioException catch (e) {
    final data = e.response?.data;
    if (data is Map && data['error'] is String) return data['error'] as String;
    return 'Could not apply code. Check your connection and try again.';
  }
}
