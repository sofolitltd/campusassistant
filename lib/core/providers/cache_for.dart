import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// How long parameterised providers keep their data after the screen using it
/// closes, so back-navigation and tab switches don't refetch.
const kParamProviderCacheTime = Duration(minutes: 5);

extension CacheForRef on Ref {
  /// Keeps an autoDispose provider alive for [duration] after its last
  /// listener leaves, then lets it dispose.
  ///
  /// For parameterised providers: `keepAlive: true` would keep every argument
  /// combination ever requested in memory for the app's lifetime, while plain
  /// autoDispose refetches on every revisit. This is the middle ground.
  void cacheFor(Duration duration) {
    final link = keepAlive();
    Timer? timer;
    onCancel(() => timer = Timer(duration, link.close));
    onResume(() => timer?.cancel());
    onDispose(() => timer?.cancel());
  }
}
