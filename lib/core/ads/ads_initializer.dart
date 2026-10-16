import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Starts the Mobile Ads SDK a little after launch instead of during it.
///
/// `MobileAds.initialize()` spins up the mediation adapters and the first
/// WebView on Android's main thread — several hundred ms on a cold start.
/// Run alongside Home's first frames (and its banner's own WebView), that
/// showed up as "Choreographer: Skipped ~60 frames". Ad loads wait on
/// [ready] so no ad work happens before the SDK has started.
abstract final class AdsInitializer {
  static final Completer<void> _ready = Completer<void>();
  static bool _started = false;

  /// Completes once the SDK has initialised (or failed to — ads then just
  /// fail to load, as before). Never completes on web.
  static Future<void> get ready => _ready.future;

  /// Call once from `main()` after `runApp`. Initialises [delay] after the
  /// first frame so splash/Home render without competing for the main thread.
  static void startDeferred({Duration delay = const Duration(seconds: 2)}) {
    if (kIsWeb || _started) return;
    _started = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(delay, () async {
        try {
          await MobileAds.instance.initialize();
        } catch (_) {
          // Ad loads will report their own failure; nothing to do here.
        }
        if (!_ready.isCompleted) _ready.complete();
      });
    });
  }
}
