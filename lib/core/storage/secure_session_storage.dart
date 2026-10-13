import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureSessionStorage {
  final FlutterSecureStorage _storage;
  SecureSessionStorage(this._storage);

  static const _tokenKey = 'auth_token';
  static const _mpinKey = 'user_mpin';
  static const _loggedOutKey = 'logged_out';

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> saveMpin(String mpin) =>
      _storage.write(key: _mpinKey, value: mpin);
  Future<String?> readMpin() => _storage.read(key: _mpinKey);

  Future<void> markLoggedIn() =>
      _storage.write(key: _loggedOutKey, value: 'false');

  Future<void> markLoggedOut() =>
      _storage.write(key: _loggedOutKey, value: 'true');

  Future<bool> isLoggedOut() async {
    final value = await _storage.read(key: _loggedOutKey);
    return value != 'false';
  }

  Future<void> clearAll() => _storage.deleteAll();
}

final secureSessionStorageProvider = Provider<SecureSessionStorage>((ref) {
  return SecureSessionStorage(const FlutterSecureStorage());
});
