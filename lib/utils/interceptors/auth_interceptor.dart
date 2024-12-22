import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/utils/helpers/auth_storage.dart';
import 'package:qms_mobile/utils/helpers/token_manager.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class AuthInterceptor extends Interceptor {
  final ApiService _apiService;
  final TokenManager _tokenManager;
  final List<String> endpointsToSkip;
  Completer<bool>? _refreshCompleter; //Lock for simultaneous refreshes

  AuthInterceptor({
    required this.endpointsToSkip,
    required ApiService apiService,
    required TokenManager tokenManager,
  })  : _apiService = apiService,
        _tokenManager = tokenManager;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!endpointsToSkip.contains(options.path)) {
      final accessToken = await _tokenManager.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.response?.data['error'] == 'ACCESS_TOKEN_EXPIRED') {
      if (_refreshCompleter == null) {
        // We are initiating a new token refresh process
        _refreshCompleter = Completer<bool>();
        final success = await _refreshAccessToken();
        _refreshCompleter?.complete(success);
        _refreshCompleter = null;
      } else {
        // We check if the user is logged in before waiting for the token to refresh
        if (await _tokenManager.getAccessToken() == null) {
          handler.next(
              err); // We pass the error on if we are not logged in
          return;
        }
        await _refreshCompleter!.future;
      }

      final newAccessToken = await _tokenManager.getAccessToken();
      if (newAccessToken != null) {
        // We try to make the request again with a new token
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        try {
          final response = await _apiService.dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler
              .next(DioException(requestOptions: err.requestOptions, error: e));
        }
      }
    } else if (err.response?.statusCode == 403 &&
        (err.response?.data['error'] == 'REFRESH_TOKEN_EXPIRED' ||
            err.response?.data['error'] == 'Forbidden')) {
      // We log out the user when the refresh token expires
      await _logoutUser();
      _refreshCompleter =
          null; // We are clearing the block because the user is logged out
      return handler.next(err); // We pass error after logging out
    }

    // We are forwarding other errors unrelated to token expiration
    handler.next(err);
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final response = await _apiService.dio.post('/auth/refresh');
      if (response.statusCode == 201 && response.data['access_token'] != null) {
        final newAccessToken = response.data['access_token'];
        await _tokenManager.setAccessToken(newAccessToken);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Refresh token failed: ${e.toString()}");
      return false;
    }
  }

  Future<void> _logoutUser() async {
    try {
      final response = await _apiService.dio.post(
        '/auth/logout',
        options: Options(extra: {'withCredentials': true}),
      );
      if (response.statusCode == 200) {
        await _tokenManager.deleteAccessToken();
        await AuthStorage.deletePassword();
        _refreshCompleter = null; // We set it to null after logging out
        navigationService.navigateAndClearStack(AppRoutes.login);
      }
    } catch (e) {
      debugPrint("Logout failed: $e");
    }
  }
}
