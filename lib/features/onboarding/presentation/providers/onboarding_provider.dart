import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/auth/presentation/providers/auth_provider.dart';
import '../../data/onboarding_local_data_source.dart';

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((
  ref,
) {
  final secureStorage = ref.watch(secureStorageProvider);
  return OnboardingLocalDataSourceImpl(secureStorage: secureStorage);
});

/// Whether the user has already completed onboarding. Read once at launch
/// and flipped to `true` (and persisted) when onboarding finishes — the
/// router redirect gates on this the same way it gates on auth state.
class OnboardingSeenNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() {
    return ref.watch(onboardingLocalDataSourceProvider).hasSeenOnboarding();
  }

  Future<void> markSeen() async {
    await ref.read(onboardingLocalDataSourceProvider).markOnboardingSeen();
    state = const AsyncValue.data(true);
  }
}

final onboardingSeenProvider =
    AsyncNotifierProvider<OnboardingSeenNotifier, bool>(
      OnboardingSeenNotifier.new,
    );
