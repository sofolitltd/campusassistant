import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void trigger() => state++;
}

final appRefreshProvider = NotifierProvider<AppRefreshNotifier, int>(AppRefreshNotifier.new);

final refreshAppDataProvider = Provider<void>((ref) {
  ref.read(appRefreshProvider.notifier).trigger();
});
