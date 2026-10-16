import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di.dart';
import '../../../../core/error/failures.dart';
import '../../../../services/firebase_api.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_user.dart';

part 'auth_provider.g.dart';

// Helpers
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

// DataSources
@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthLocalDataSourceImpl(secureStorage: secureStorage);
}

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRemoteDataSourceImpl(
    apiClient: apiClient,
    localDataSource: localDataSource,
  );
}

// Respository
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final local = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remote, localDataSource: local);
}

// UseCases
@Riverpod(keepAlive: true)
LoginUsecase loginUser(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUsecase(repository);
}

bool _isNetworkError(Failure f) => f is NetworkFailure;

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  // Not `late final`: a notifier's build() re-runs on the same instance when
  // this provider is invalidated (e.g. after editing the profile), so the
  // field is reassigned each build — `final` would throw
  // LateInitializationError ("already initialized") on that second run.
  late AuthRepository _repository;

  // Bumped on every build/login/logout so a background `/me` refresh that
  // finishes after the session changed doesn't overwrite the newer state.
  int _generation = 0;

  @override
  Future<User?> build() async {
    _repository = ref.watch(authRepositoryProvider);
    final generation = ++_generation;
    final user = await _checkAuthStatus(generation);
    if (user != null) _initNotificationsSoon();
    return user;
  }

  /// Resolves the signed-in user for startup.
  ///
  /// With a token and a cached profile, returns the cache immediately and
  /// refreshes `/me` in the background — the splash screen used to block on
  /// that call for 2–15 s on slow networks. Only a first launch (no cached
  /// profile) waits on the network.
  Future<User?> _checkAuthStatus(int generation) async {
    if (!await _repository.isAuthenticated()) return null;

    final cached = (await _repository.getCachedUser()).fold(
      (_) => null,
      (user) => user,
    );
    if (cached != null) {
      unawaited(_revalidate(generation));
      return cached;
    }

    // No cached profile to show, so offline here means signed-out UI.
    return (await _fetchCurrentUser()).user;
  }

  Future<void> _revalidate(int generation) async {
    final fetched = await _fetchCurrentUser();
    // Session changed (logout, login, invalidation) while we were waiting.
    if (generation != _generation || !ref.mounted) return;
    // Offline: keep showing the cached profile.
    if (fetched.isOffline) return;
    state = AsyncValue.data(fetched.user);
  }

  /// Fetches `/me`, refreshing the access token once on an auth failure.
  /// Logs out (and returns a null user) when the session is definitively
  /// invalid; network failures are reported as offline and never log out.
  Future<({User? user, bool isOffline})> _fetchCurrentUser() async {
    final result = await _repository.getCurrentUser();
    return result.fold((failure) async {
      if (_isNetworkError(failure)) return (user: null, isOffline: true);

      final refreshResult = await _repository.refreshAccessToken();
      return refreshResult.fold(
        (refreshFailure) async {
          if (_isNetworkError(refreshFailure)) {
            return (user: null, isOffline: true);
          }
          await _repository.logout();
          return (user: null, isOffline: false);
        },
        (_) async {
          final retryResult = await _repository.getCurrentUser();
          return retryResult.fold((e) async {
            if (_isNetworkError(e)) return (user: null, isOffline: true);
            await _repository.logout();
            return (user: null, isOffline: false);
          }, (user) => (user: user, isOffline: false));
        },
      );
    }, (user) => (user: user, isOffline: false));
  }

  /// FCM setup (permission prompt, token, local-notification channels) is
  /// all platform-channel work on Android's main thread; started a beat
  /// after sign-in so it doesn't land in the same frames as Home's first
  /// render. Ads init is deferred separately, later still.
  void _initNotificationsSoon() {
    unawaited(
      Future.delayed(
        const Duration(seconds: 1),
        () => FirebaseApi().initNotifications(),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    _generation++;
    state = const AsyncValue.loading();
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (user) {
        state = AsyncValue.data(user);
        _initNotificationsSoon();
      },
    );
  }

  Future<void> logout() async {
    _generation++;
    state = const AsyncValue.loading();
    // Clear the local session first and resolve immediately — the router
    // and ProfilePage both watch this state, and gating it behind the
    // network device-unregister call (below) used to leave the user
    // staring at a half-loaded profile shell for as long as that request
    // took (up to the 15s connect timeout on a bad connection). The
    // unregister call is best-effort and already swallows its own errors
    // (see FirebaseApi.unregisterCurrentDevice), so it's safe to fire it
    // in the background instead of blocking logout on it.
    await _repository.logout();
    state = const AsyncValue.data(null);
    unawaited(FirebaseApi().unregisterCurrentDevice());
  }
}
