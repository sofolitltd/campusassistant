import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/auth/token_store.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> cacheRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> deleteCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const String cachedTokenKey = TokenStore.accessTokenKey;
  static const String cachedRefreshTokenKey = TokenStore.refreshTokenKey;
  static const String cachedUserKey = 'CACHED_USER_PROFILE';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheToken(String token) {
    return TokenStore.instance.setAccessToken(token);
  }

  @override
  Future<String?> getToken() {
    return TokenStore.instance.getAccessToken();
  }

  @override
  Future<void> deleteToken() {
    return TokenStore.instance.clearAccessToken();
  }

  @override
  Future<void> cacheRefreshToken(String token) {
    return TokenStore.instance.setRefreshToken(token);
  }

  @override
  Future<String?> getRefreshToken() {
    return TokenStore.instance.getRefreshToken();
  }

  @override
  Future<void> deleteRefreshToken() {
    return TokenStore.instance.clearRefreshToken();
  }

  @override
  Future<void> cacheUser(UserModel user) {
    final json = jsonEncode(user.toJson());
    return secureStorage.write(key: cachedUserKey, value: json);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final json = await secureStorage.read(key: cachedUserKey);
    if (json == null || json.isEmpty) return null;
    try {
      return UserModel.fromJson(jsonDecode(json));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteCachedUser() {
    return secureStorage.delete(key: cachedUserKey);
  }
}
