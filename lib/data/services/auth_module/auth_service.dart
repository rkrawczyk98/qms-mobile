import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qms_mobile/data/services/api_service.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/utils/helpers/auth_storage.dart';
import 'package:qms_mobile/utils/helpers/token_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthService {
  final ApiService _apiService;
  final TokenManager _tokenManager;

  AuthService(this._apiService, this._tokenManager);

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiService.dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 201 && response.data['access_token'] != null) {
        final accessToken = response.data['access_token'];
        await _tokenManager.setAccessToken(accessToken);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Login failed: $e");
      return false;
    }
  }

  Future<String?> changePassword(
      String currentPassword, String newPassword) async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return null;

    final localizations = AppLocalizations.of(context)!;

    try {
      final response =
          await _apiService.dio.patch('/users/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
      if (response.statusCode == 200) {
        return response.data['message'];
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        return localizations.changePasswordErrorInvalidCurrentPassword;
      } else if (e.response != null && e.response?.statusCode == 404) {
        return localizations.changePasswordErrorUserNotFound;
      } else {
        return localizations.changePasswordErrorGeneral;
      }
    }
    return null;
  }

  Future<bool> logout() async {
    try {
      final response = await _apiService.dio.post(
        '/auth/logout',
        options: Options(extra: {'withCredentials': true}),
      );
      if (response.statusCode == 200) {
        await _tokenManager.deleteAccessToken();
        await AuthStorage.deleteLoginData();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Logout failed: $e");
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    return await _tokenManager.getAccessToken();
  }
}
