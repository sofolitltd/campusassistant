import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/di.dart';
import '/core/providers/app_refresh_provider.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

const _notificationsPageSize = 20;

/// Paginated notification inbox. Exposes the same `AsyncValue<List<AppNotification>>`
/// shape the rest of the app already watches (unreadCountProvider,
/// ref.invalidate(notificationsProvider) on push arrival, etc.) — the only
/// difference from the old plain FutureProvider is that build() now fetches
/// just the first page instead of the user's entire history, with loadMore()
/// to page further back and updateLocal() for optimistic single-item edits
/// (e.g. marking one notification read without refetching everything).
class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  int _offset = 0;
  int _totalCount = 0;
  bool _isLoadingMore = false;

  bool get hasMore => _offset < _totalCount;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<AppNotification>> build() async {
    // Refetch whenever the app-wide refresh trigger fires (e.g. on app
    // resume, see main.dart's didChangeAppLifecycleState) or a push
    // notification arrives (see FirebaseApi._refreshNotifications), not
    // just on first watch.
    ref.watch(appRefreshProvider);
    final repo = ref.watch(notificationRepositoryProvider);
    final page = await repo.getNotifications(offset: 0, limit: _notificationsPageSize);
    _offset = page.items.length;
    _totalCount = page.totalCount;
    return page.items;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;
    _isLoadingMore = true;
    try {
      final repo = ref.read(notificationRepositoryProvider);
      final page = await repo.getNotifications(offset: _offset, limit: _notificationsPageSize);
      _offset += page.items.length;
      _totalCount = page.totalCount;
      final current = state.value ?? [];
      state = AsyncValue.data([...current, ...page.items]);
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Applies [update] to the notification with [id] in local state only, for
  /// instant UI feedback (e.g. isRead flipping) without waiting on/forcing a
  /// full-list refetch just to reflect a single-row change.
  void updateLocal(String id, AppNotification Function(AppNotification) update) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data([
      for (final n in current) n.id == id ? update(n) : n,
    ]);
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(
      NotificationsNotifier.new,
    );

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).asData?.value ?? [];
  return notifications.where((n) => !n.isRead).length;
});
