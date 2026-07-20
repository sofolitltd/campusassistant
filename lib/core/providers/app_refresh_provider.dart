import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void trigger() => state++;
}

/// Bump this to make anything watching it (e.g. notificationsProvider)
/// refetch. Call sites should do `ref.read(appRefreshProvider.notifier).trigger()`
/// directly — this used to be wrapped in a `Provider<void>` that triggered
/// as a side effect of being read, but that only fired once (a plain
/// Provider caches its result after the first read) and could violate
/// Riverpod's no-mutating-another-provider-while-building rule depending on
/// when it was first read, which cascaded into a build-loop crash on web.
final appRefreshProvider = NotifierProvider<AppRefreshNotifier, int>(
  AppRefreshNotifier.new,
);
