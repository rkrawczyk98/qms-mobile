import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyUsername = 'username';
  static const _keyPassword = 'password';

  // Save login details
  static Future<void> saveLoginData(String username, String password) async {
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyPassword, value: password);
  }

  // Delete login information
  static Future<void> deleteLoginData() async {
    await _storage.delete(key: _keyUsername);
    await _storage.delete(key: _keyPassword);
  }

  // Delete only the password
  static Future<void> deletePassword() async {
    await _storage.delete(key: _keyPassword);
  }

  // Get login details
  static Future<Map<String, String?>> getLoginData() async {
    final username = await _storage.read(key: _keyUsername);
    final password = await _storage.read(key: _keyPassword);
    return {'username': username, 'password': password};
  }
}
