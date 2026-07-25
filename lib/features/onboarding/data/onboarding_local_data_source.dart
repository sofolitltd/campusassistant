import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> hasSeenOnboarding();
  Future<void> markOnboardingSeen();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const String _seenKey = 'HAS_SEEN_ONBOARDING';

  OnboardingLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<bool> hasSeenOnboarding() async {
    final value = await secureStorage.read(key: _seenKey);
    return value == 'true';
  }

  @override
  Future<void> markOnboardingSeen() {
    return secureStorage.write(key: _seenKey, value: 'true');
  }
}
