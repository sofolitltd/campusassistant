import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

/// Preloads/shows a single rewarded ad, shared app-wide via
/// [rewardedAdManagerProvider] so multiple ResourceCard/ContentCard widgets
/// visible at once don't each independently request their own ad.
///
/// google_mobile_ads has no web platform implementation at all (only
/// android/ios are registered in its plugin manifest) — calling its APIs on
/// web throws MissingPluginException, not just no-ops. Every method here
/// guards on kIsWeb first as a result.
class RewardedAdManager {
  RewardedAd? _ad;
  bool _isLoading = false;

  /// Starts loading an ad if one isn't already loaded/loading. Safe to call
  /// repeatedly — no-ops on web, and once a load is in flight or an ad is
  /// already ready.
  void preload() {
    if (kIsWeb || _ad != null || _isLoading) return;
    _isLoading = true;
    RewardedAd.load(
      adUnitId: AdConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
        },
      ),
    );
  }

  /// Shows the preloaded ad if one is ready. Returns true if the user
  /// watched it through to earning the reward, false if no ad was ready
  /// (including always on web) or they closed it early — callers decide
  /// how strict to be about that. Always kicks off a fresh preload for next
  /// time before returning.
  Future<bool> show() async {
    if (kIsWeb) return false;

    final ad = _ad;
    if (ad == null) {
      preload();
      return false;
    }
    _ad = null;

    final completer = Completer<bool>();
    var earned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preload();
        if (!completer.isCompleted) completer.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        preload();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await ad.show(
      onUserEarnedReward: (ad, reward) {
        earned = true;
      },
    );

    return completer.future;
  }
}

final rewardedAdManagerProvider = Provider<RewardedAdManager>((ref) {
  return RewardedAdManager();
});
