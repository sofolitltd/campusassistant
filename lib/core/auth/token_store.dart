import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Process-wide, in-memory cache of the auth tokens, written through to
/// secure storage.
///
/// Every API request and WebSocket (re)connect needs the access token;
/// reading it from the Keystore/Keychain each time costs a platform-channel
/// round trip. Storage is read once per token, and every login, refresh and
/// logout goes through here, so the cached value never goes stale.
///
/// This is the only code that should touch [accessTokenKey] and
/// [refreshTokenKey] in storage. A background isolate gets its own instance
/// and simply loads from storage on first use.
class TokenStore {
  TokenStore._();

  static final TokenStore instance = TokenStore._();

  static const String accessTokenKey = 'CACHED_AUTH_TOKEN';
  static const String refreshTokenKey = 'CACHED_REFRESH_TOKEN';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  final _access = _CachedSecureValue(_storage, accessTokenKey);
  final _refresh = _CachedSecureValue(_storage, refreshTokenKey);

  Future<String?> getAccessToken() => _access.read();
  Future<void> setAccessToken(String token) => _access.write(token);
  Future<void> clearAccessToken() => _access.delete();

  Future<String?> getRefreshToken() => _refresh.read();
  Future<void> setRefreshToken(String token) => _refresh.write(token);
  Future<void> clearRefreshToken() => _refresh.delete();
}

class _CachedSecureValue {
  _CachedSecureValue(this._storage, this._key);

  final FlutterSecureStorage _storage;
  final String _key;

  String? _value;
  bool _loaded = false;
  Future<String?>? _loading;

  Future<String?> read() async {
    if (_loaded) return _value;
    // Concurrent first reads (app start fires several requests at once)
    // share a single storage read.
    final stored = await (_loading ??= _storage.read(key: _key));
    _loading = null;
    // A write/delete that landed while the read was in flight wins.
    if (!_loaded) {
      _value = stored;
      _loaded = true;
    }
    return _value;
  }

  Future<void> write(String value) {
    // Memory first, so requests issued before the write finishes already
    // carry the new token.
    _value = value;
    _loaded = true;
    return _storage.write(key: _key, value: value);
  }

  Future<void> delete() {
    _value = null;
    _loaded = true;
    return _storage.delete(key: _key);
  }
}
