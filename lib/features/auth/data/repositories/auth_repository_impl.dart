import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

Failure _classifyError(Object e) {
  if (e is DioException) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkFailure('No internet connection');
    }

    // Prefer the API's own message. The backend replies {"error": "..."} on
    // failure; without this the user is shown the raw
    // "DioException [bad response]: ..." dump.
    final data = e.response?.data;
    if (data is Map) {
      final message = (data['error'] ?? data['message'])?.toString();
      if (message != null && message.isNotEmpty) {
        // verify-reset-code reports how many guesses are left; surface it so
        // the user knows when to request a fresh code.
        final left = data['attempts_remaining'];
        if (left is int) {
          return ServerFailure(
            '$message ($left ${left == 1 ? 'attempt' : 'attempts'} left)',
          );
        }
        return ServerFailure(message);
      }
    }
  }
  return ServerFailure(e.toString());
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      // Cache user profile for offline access
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(_classifyError(e));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String? gender,
    String? universityId,
    String? departmentId,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        email,
        password,
        firstName,
        lastName,
        phone,
        gender,
        universityId,
        departmentId,
      );
      // Cache user profile for offline access
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(_classifyError(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      await localDataSource.deleteRefreshToken();
      await localDataSource.deleteCachedUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      // Cache user profile for offline access
      await localDataSource.cacheUser(user);
      return Right(user.toEntity());
    } catch (e) {
      return Left(_classifyError(e));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      if (user == null) {
        return const Left(CacheFailure('No cached user profile'));
      }
      return Right(user.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(_classifyError(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifyResetCode(
    String email,
    String code,
  ) async {
    try {
      final token = await remoteDataSource.verifyResetCode(email, code);
      return Right(token);
    } catch (e) {
      return Left(_classifyError(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String email,
    String resetToken,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.resetPassword(email, resetToken, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(_classifyError(e));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String oldPassword,
    required String newPassword,
    bool logoutOtherDevices = true,
  }) async {
    try {
      final result = await remoteDataSource.changePassword(
        oldPassword,
        newPassword,
        logoutOtherDevices: logoutOtherDevices,
      );
      final newToken = result['access_token']?.toString();
      if (newToken == null || newToken.isEmpty) {
        return const Left(ServerFailure('No access token returned'));
      }
      return Right(newToken);
    } catch (e) {
      return Left(_classifyError(e));
    }
  }

  @override
  Future<Either<Failure, String>> refreshAccessToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return Left(AuthFailure('No refresh token stored'));
      }
      final newAccessToken = await remoteDataSource.refreshToken(refreshToken);
      return Right(newAccessToken);
    } catch (e) {
      return Left(_classifyError(e));
    }
  }
}
