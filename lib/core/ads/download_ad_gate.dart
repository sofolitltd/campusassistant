import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/providers/perks_provider.dart';
import 'interstitial_ad_manager.dart';

/// Shows an interstitial before every coin-less Basic user's download.
///
/// Not a gate: the download always proceeds afterwards, whether the ad
/// showed, was skipped after a few seconds, or failed to load.
/// That keeps it a natural pause rather than an "ad for access" trade,
/// which AdMob only permits on rewarded formats — and it never traps a
/// student behind a study resource because of a flaky ad network.
///
/// Ad-free/coin-free users (Pro or an access grant) and web return
/// immediately (web: google_mobile_ads has no web implementation at all).
Future<void> showDownloadInterstitial(WidgetRef ref) async {
  if (kIsWeb || ref.read(isAdFreeProvider) || ref.read(isCoinFreeProvider)) {
    return;
  }
  await ref.read(interstitialAdManagerProvider).show();
}
