import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> cacheRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const String cachedTokenKey = 'CACHED_AUTH_TOKEN';
  static const String cachedRefreshTokenKey = 'CACHED_REFRESH_TOKEN';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheToken(String token) {
    return secureStorage.write(key: cachedTokenKey, value: token);
  }

  @override
  Future<String?> getToken() {
    return secureStorage.read(key: cachedTokenKey);
  }

  @override
  Future<void> deleteToken() {
    return secureStorage.delete(key: cachedTokenKey);
  }

  @override
  Future<void> cacheRefreshToken(String token) {
    return secureStorage.write(key: cachedRefreshTokenKey, value: token);
  }

  @override
  Future<String?> getRefreshToken() {
    return secureStorage.read(key: cachedRefreshTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() {
    return secureStorage.delete(key: cachedRefreshTokenKey);
  }
}
