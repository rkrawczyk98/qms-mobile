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

    // Extracting error message from server response or setting default message
    String errorMessage;
    if (err.response != null && err.response?.data != null) {
      final message = err.response?.data['message'];

      if (message is List) {
        // If 'message' is a list, combine messages into one
        errorMessage = message.join(', \n');
      } else if (message is String) {
        errorMessage = message;
      } else {
        errorMessage = localizations.unknownError;
      }
    } else {
      errorMessage = localizations.failedToConnect;
    }

    // Displaying a custom snackbar with error information
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

    super.onError(err, handler); // Forwarding the error
  }
}
