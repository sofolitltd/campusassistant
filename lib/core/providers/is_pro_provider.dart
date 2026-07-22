import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/auth/presentation/providers/auth_provider.dart';

/// Single source of truth for "is the current user Pro" — reads
/// currentUserProvider directly rather than the ProfileModel copy of the
/// same field (userProvider's `information.status.subscriber` is built
/// from `User.subscriptionStatus` at construction time, so it's never more
/// current than this).
final isProUserProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider).value;
  return user?.subscriptionStatus == 'pro';
});
