import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';
import 'ads_initializer.dart';

/// Preloads/shows a single interstitial ad, shared app-wide via
/// [interstitialAdManagerProvider] so every card on screen reuses one ad.
///
/// Deliberately uncapped: every coin-less Basic download gets an ad. Coins
/// and Pro are the ad-free paths, so a cap would only make heavy
/// downloaders free and remove their reason to earn coins or upgrade.
///
/// Interstitials never grant a reward (AdMob only allows rewards on the
/// rewarded formats) — callers show one as a pause before a download that
/// happens regardless of whether the ad loaded or was skipped.
class InterstitialAdManager {
  InterstitialAd? _ad;
  bool _isLoading = false;

  /// Starts loading an ad if one isn't already loaded/loading. Safe to call
  /// repeatedly — no-ops on web, and once a load is in flight or an ad is
  /// already ready.
  void preload() {
    if (kIsWeb || _ad != null || _isLoading) return;
    _isLoading = true;
    // Queued behind the deferred SDK init (see AdsInitializer).
    AdsInitializer.ready.then((_) => _load());
  }

  void _load() {
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
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

  /// Shows the preloaded ad if one is ready. Completes once
  /// the ad is dismissed (or immediately if nothing was shown) — never throws
  /// and never blocks the caller's next step. Always kicks off a fresh
  /// preload for next time.
  Future<void> show() async {
    if (kIsWeb) return;

    final ad = _ad;
    if (ad == null) {
      preload();
      return;
    }
    _ad = null;

    final completer = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preload();
        if (!completer.isCompleted) completer.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        preload();
        if (!completer.isCompleted) completer.complete();
      },
    );

    await ad.show();
    return completer.future;
  }
}

final interstitialAdManagerProvider = Provider<InterstitialAdManager>((ref) {
  return InterstitialAdManager();
});
