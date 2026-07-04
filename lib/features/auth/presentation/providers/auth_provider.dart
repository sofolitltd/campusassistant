import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di.dart';
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

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  late final AuthRepository _repository;

  @override
  Future<User?> build() async {
    _repository = ref.watch(authRepositoryProvider);
    return _checkAuthStatus();
  }

  Future<User?> _checkAuthStatus() async {
    final isAuthenticated = await _repository.isAuthenticated();
    if (isAuthenticated) {
      // Try to get user with current access token
      final result = await _repository.getCurrentUser();
      return result.fold((failure) async {
        // Access token likely expired — try refreshing silently
        final refreshResult = await _repository.refreshAccessToken();
        return refreshResult.fold(
          (refreshFailure) {
            // Refresh token also expired/invalid → force logout
            _repository.logout();
            return null;
          },
          (_) async {
            // Got a new access token — retry getting user
            final retryResult = await _repository.getCurrentUser();
            return retryResult.fold((e) {
              _repository.logout();
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
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _repository.logout();
    state = const AsyncValue.data(null);
  }
}
