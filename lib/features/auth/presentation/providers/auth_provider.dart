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
  late final AuthRepository _repository;

  @override
  Future<User?> build() async {
    _repository = ref.watch(authRepositoryProvider);
    final user = await _checkAuthStatus();
    if (user != null) {
      unawaited(FirebaseApi().initNotifications());
    }
    return user;
  }

  Future<User?> _checkAuthStatus() async {
    final isAuthenticated = await _repository.isAuthenticated();
    if (isAuthenticated) {
      final result = await _repository.getCurrentUser();
      return result.fold((failure) async {
        if (_isNetworkError(failure)) {
          // Offline: try to return cached user profile so the app
          // can still show profile data with cached info.
          final cached = await _repository.getCachedUser();
          return cached.fold((_) => null, (user) => user);
        }

        final refreshResult = await _repository.refreshAccessToken();
        return refreshResult.fold(
          (refreshFailure) {
            if (!_isNetworkError(refreshFailure)) {
              _repository.logout();
            }
            return null;
          },
          (_) async {
            final retryResult = await _repository.getCurrentUser();
            return retryResult.fold((e) {
              if (!_isNetworkError(e)) {
                _repository.logout();
              }
              return null;
            }, (user) => user);
          },
        );
      }, (user) => user);
    } else {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (user) {
        state = AsyncValue.data(user);
        unawaited(FirebaseApi().initNotifications());
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await FirebaseApi().unregisterCurrentDevice();
    await _repository.logout();
    state = const AsyncValue.data(null);
  }
}
