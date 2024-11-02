import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qms_mobile/data/services/api_service.dart';
import 'package:qms_mobile/utils/helpers/auth_storage.dart';

class AuthService {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthService(this._apiService);

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(sendTimeout: const Duration(seconds: 5)),
      );

      if (response.statusCode == 201 && response.data['access_token'] != null) {
        final accessToken = response.data['access_token'];
        await _secureStorage.write(key: 'access_token', value: accessToken);
        return true;
      }
      return false;
    } catch (e) {
      print("Login failed: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
  await AuthStorage.deleteLoginData();
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }
}
