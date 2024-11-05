import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qms_mobile/data/models/DTOs/auth/user_info.dart';
import 'package:qms_mobile/data/models/DTOs/user/user_role_response_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/utils/exceptions/conflict_exception.dart';

class UserService {
  final ApiService _apiService;

  UserService(this._apiService);

  // Creating a new user
  Future<bool> createUser(String username, String password) async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return false;
    final localizations = AppLocalizations.of(context)!;

    try {
      final response = await _apiService.dio.post('/users', data: {
        'username': username,
        'password': password,
      });
      return response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint("Create user failed: $e");
      if (e.response?.statusCode == 409) {
        throw ConflictException(localizations.userAlreadyExists(username));
      } else {
        throw Exception(localizations.unexpectedError);
      }
    }
  }

  // Downloading a list of users with assigned roles
  Future<List<UserRoleResponseDto>?> getUsersWithRoles() async {
    try {
      final response = await _apiService.dio.get('/users/users-roles');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((user) => UserRoleResponseDto.fromJson(user))
            .toList();
      }
    } catch (e) {
      debugPrint("Get users with roles failed: $e");
    }
    return null;
  }

  // Changing the password of a logged-in user
  Future<String?> changePassword(
      String currentPassword, String newPassword) async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return null;
    final localizations = AppLocalizations.of(context)!;

    try {
      final response = await _apiService.dio.patch(
        '/users/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
      return response.statusCode == 200
          ? response.data['message']
          : localizations.changePasswordErrorGeneral;
    } on DioException catch (e) {
      debugPrint("Change password failed: $e");
      return e.response?.statusCode == 400
          ? localizations.changePasswordErrorInvalidCurrentPassword
          : localizations.changePasswordErrorGeneral;
    }
  }

// Administrator resets user password
  Future<bool> resetPassword(int userId, String newPassword) async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return false;
    // final localizations = AppLocalizations.of(context)!;

    try {
      await _apiService.dio.patch(
        '/users/reset-password',
        data: {
          'userId': userId,
          'newPassword': newPassword,
        },
      );
      return true;
    } catch (e) {
      debugPrint("Reset password error caught by interceptor: $e");
      // Interceptor will handle the error snackbar display, so no need to handle it here.
    }
    return false;
  }

  Future<UserInfo?> fetchUserInfo({int? userId}) async {
    try {
      // Sprawdź, czy `userId` jest podany; jeśli tak, dołącz go do URL-a
      final endpoint = userId != null
          ? '/users/user-info?userId=$userId'
          : '/users/user-info';

      final response = await _apiService.dio.get(endpoint);
      if (response.statusCode == 200) {
        return UserInfo.fromJson(response.data);
      }
    } catch (e) {
      debugPrint("Fetch user info failed: $e");
    }
    return null;
  }

  // Deleting a user
  Future<bool> deleteUser(int userId) async {
    try {
      final response = await _apiService.dio.delete('/users/$userId');
      return response.statusCode == 204;
    } catch (e) {
      debugPrint("Delete user failed: $e");
      return false;
    }
  }
}
