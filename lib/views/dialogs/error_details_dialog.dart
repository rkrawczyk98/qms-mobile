import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorDetailsDialog extends StatelessWidget {
  final String errorMessage;
  final String errorCode;

  const ErrorDetailsDialog({
    super.key,
    required this.errorMessage,
    this.errorCode = "",
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.errorDetails),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(localizations.message(errorMessage)),
            if (errorCode.isNotEmpty) Text(localizations.errorCode(errorCode)),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(localizations.close,
              style: Theme.of(context).textTheme.bodySmall),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
