import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/di.dart';
import '/services/notification_preference_repository.dart';

final notificationPreferenceRepositoryProvider =
    Provider<NotificationPreferenceRepository>((ref) {
      return NotificationPreferenceRepository(
        apiClient: ref.watch(apiClientProvider),
      );
    });

class NotificationPreferencesNotifier
    extends AsyncNotifier<Map<String, bool>> {
  @override
  Future<Map<String, bool>> build() {
    return _fetch();
  }

  Future<Map<String, bool>> _fetch() {
    final repo = ref.watch(notificationPreferenceRepositoryProvider);
    return repo.getPreferences();
  }

  /// Optimistically flips [category] to [enabled] so the switch responds
  /// instantly, then persists it — reverting on failure. A full refetch on
  /// every toggle (like ManageDevicesNotifier does after a mutation) would
  /// cause a visible flicker on a settings list of switches.
  Future<void> setCategory(String category, bool enabled) async {
    final previous = state;
    final current = Map<String, bool>.from(state.value ?? {});
    current[category] = enabled;
    state = AsyncValue.data(current);

    try {
      final repo = ref.read(notificationPreferenceRepositoryProvider);
      await repo.updatePreference(category, enabled);
    } catch (e) {
      state = previous;
      rethrow;
    }
  }
}

final notificationPreferencesProvider =
    AsyncNotifierProvider<NotificationPreferencesNotifier, Map<String, bool>>(
      NotificationPreferencesNotifier.new,
    );
