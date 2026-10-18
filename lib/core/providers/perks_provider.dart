import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/auth/presentation/providers/auth_provider.dart';
import 'is_pro_provider.dart';

/// Perks from admin access grants (campus launch offers, exam-season
/// promos, ambassadors), as resolved by the API onto `/me`'s `perks` field.
/// An `until` of null with the perk on means "no end date".
class GrantPerks {
  final bool adFree;
  final DateTime? adFreeUntil;
  final bool coinFree;
  final DateTime? coinFreeUntil;
  final String label;

  const GrantPerks({
    this.adFree = false,
    this.adFreeUntil,
    this.coinFree = false,
    this.coinFreeUntil,
    this.label = '',
  });

  static const none = GrantPerks();

  /// Parses `/me`'s `perks`, dropping any perk whose end date has passed —
  /// the profile is cached, so it can outlive the grant it was fetched under.
  factory GrantPerks.fromJson(Map<String, dynamic>? json, DateTime now) {
    if (json == null) return none;
    DateTime? until(String key) =>
        json[key] is String ? DateTime.tryParse(json[key] as String) : null;
    bool live(bool on, DateTime? end) =>
        on && (end == null || end.isAfter(now));

    final adUntil = until('ad_free_until');
    final coinUntil = until('coin_free_until');
    return GrantPerks(
      adFree: live(json['ad_free'] == true, adUntil),
      adFreeUntil: adUntil,
      coinFree: live(json['coin_free'] == true, coinUntil),
      coinFreeUntil: coinUntil,
      label: json['label'] as String? ?? '',
    );
  }

  bool get any => adFree || coinFree;

  /// When the last active perk ends; null if one never ends (or none apply).
  DateTime? get endsAt {
    final ends = [if (adFree) adFreeUntil, if (coinFree) coinFreeUntil];
    if (ends.isEmpty || ends.contains(null)) return null;
    return ends.whereType<DateTime>().reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

final grantPerksProvider = Provider<GrantPerks>((ref) {
  final user = ref.watch(currentUserProvider).value;
  return GrantPerks.fromJson(user?.perks, DateTime.now());
});

/// No ads of any kind: Pro, or an ad-free access grant.
final isAdFreeProvider = Provider<bool>((ref) {
  return ref.watch(isProUserProvider) || ref.watch(grantPerksProvider).adFree;
});

/// Free-tier resources cost no coins: Pro, or a coin-free access grant.
/// Pro-only content still needs Pro — this never unlocks it.
final isCoinFreeProvider = Provider<bool>((ref) {
  return ref.watch(isProUserProvider) || ref.watch(grantPerksProvider).coinFree;
});
