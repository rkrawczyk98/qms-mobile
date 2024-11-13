import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/dialogs/error_details_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/routes/navigation_service.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return;

    final localizations = AppLocalizations.of(context)!;

    // If the error is `401` with "ACCESS_TOKEN_EXPIRED", we don't show the error,
    // since AuthInterceptor will take care of refreshing the token.
    if (err.response?.statusCode == 401 &&
        err.response?.data['error'] == 'ACCESS_TOKEN_EXPIRED') {
      return; // We ignore the error because it is handled by AuthInterceptor
    }

    // If the error is `403` with "REFRESH TOKEN EXPIRED" or "Forbidden", a session expiration message is displayed.
    if (err.response?.statusCode == 403 &&
        (err.response?.data['error'] == 'REFRESH_TOKEN_EXPIRED' ||
            err.response?.data['error'] == 'Forbidden')) {
      final sessionExpiredMessage = localizations.sessionExpired;

      // We display a custom snackbar informing about session expiration
      CustomSnackbar.showErrorSnackbar(
        context,
        sessionExpiredMessage,
        onActionTap: () {
          showDialog(
            context: context,
            builder: (context) => ErrorDetailsDialog(
              errorMessage: sessionExpiredMessage,
              errorCode: err.response?.statusCode?.toString() ?? '',
            ),
          );
        },
      );
      return; // We ignore further processing of the error.
    }

    // Default error handling - we display a message for other errors
    String errorMessage;
    if (err.response != null && err.response?.data != null) {
      final message = err.response?.data['message'];

      if (message is List) {
        // If 'message' is a list, we concatenate the messages into one string
        errorMessage = message.join(', \n');
      } else if (message is String) {
        errorMessage = message;
      } else {
        errorMessage = localizations.unknownError;
      }
    } else {
      errorMessage = localizations.failedToConnect;
    }

    // Display custom snackbar for general errors
    CustomSnackbar.showErrorSnackbar(
      context,
      errorMessage,
      onActionTap: () {
        showDialog(
          context: context,
          builder: (context) => ErrorDetailsDialog(
            errorMessage: errorMessage,
            errorCode: err.response?.statusCode?.toString() ?? '',
          ),
        );
      },
    );

    super.onError(err, handler); // We are forwarding the error further
  }
}
