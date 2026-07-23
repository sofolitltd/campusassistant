import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bumped after any Career mutation (create/edit/delete job, cancel
/// reminder, save circular to My Jobs) so feed/list providers refetch,
/// same pattern as CommunityRefreshNotifier / lostFoundRefreshProvider.
class CareerRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state++;
}

final careerRefreshProvider =
    NotifierProvider<CareerRefreshNotifier, int>(CareerRefreshNotifier.new);
