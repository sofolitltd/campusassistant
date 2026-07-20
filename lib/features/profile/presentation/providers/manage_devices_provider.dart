import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/services/device_repository.dart';
import '/services/firebase_api.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepository(apiClient: ref.watch(apiClientProvider));
});

class ManageDevicesNotifier extends AsyncNotifier<List<Device>> {
  @override
  Future<List<Device>> build() {
    return _fetch();
  }

  Future<List<Device>> _fetch() {
    final repo = ref.watch(deviceRepositoryProvider);
    return repo.listDevices(currentFcmToken: FirebaseApi().currentToken);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> removeDevice(String id) async {
    final repo = ref.read(deviceRepositoryProvider);
    await repo.removeDevice(id);
    await refresh();
  }

  /// Bumps TokenVersion for the whole account (invalidating every issued
  /// access token, including this device's) and clears all device rows.
  /// The caller is responsible for a local logout right after this succeeds.
  Future<void> logoutAll() async {
    final repo = ref.read(deviceRepositoryProvider);
    await repo.logoutAll();
  }

  /// Signs out every other device while keeping this one logged in — stores
  /// the fresh access token this endpoint returns, since this device's
  /// TokenVersion changed too and its old token would otherwise stop working.
  Future<void> logoutOthers() async {
    final repo = ref.read(deviceRepositoryProvider);
    final newToken = await repo.logoutOthers(
      currentFcmToken: FirebaseApi().currentToken,
    );
    await ref.read(authLocalDataSourceProvider).cacheToken(newToken);
    await refresh();
  }
}

final manageDevicesProvider =
    AsyncNotifierProvider<ManageDevicesNotifier, List<Device>>(
      ManageDevicesNotifier.new,
    );
