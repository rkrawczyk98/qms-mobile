import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/utils/externsions/date_formater_extensions.dart';

enum FilterOperation { eq, lt, gt, between, like }

extension AppLocalizationsExtension on AppLocalizations {
  String translateOperationName(FilterOperation operation) {
    switch (operation) {
      case FilterOperation.eq:
        return operationName_eq;
      case FilterOperation.lt:
        return operationName_lt;
      case FilterOperation.gt:
        return operationName_gt;
      case FilterOperation.between:
        return operationName_between;
      case FilterOperation.like:
        return operationName_like;
    }
  }
}

abstract class FilterWidgetBuilder {
  Widget build(
      FilterOperation operation, void Function(dynamic value) onValueChanged);
}

class FilterOption {
  final String displayName;
  final String objectName;
  final String databaseName;
  final List<FilterOperation> allowedFilteringOperations;
  final FilterWidgetBuilder widgetBuilder;

  Map<FilterOperation, String> operationMap(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return {
      for (var operation in allowedFilteringOperations)
        operation: localizations.translateOperationName(operation)
    };
  }

  FilterOption({
    required this.displayName,
    required this.objectName,
    required this.databaseName,
    required this.allowedFilteringOperations,
    required this.widgetBuilder,
  });
}

class IntNumberFilterWidgetBuilder extends FilterWidgetBuilder {
  final BuildContext context;

  IntNumberFilterWidgetBuilder({required this.context});

  @override
  Widget build(
      FilterOperation operation, void Function(dynamic value) onValueChanged) {
    final localization = AppLocalizations.of(context)!;
    return switch (operation) {
      FilterOperation.eq ||
      FilterOperation.lt ||
      FilterOperation.gt =>
        TextField(
          decoration: InputDecoration(
            labelText:
                '${localization.enterValue} (${localization.translateOperationName(operation)})',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => onValueChanged(int.tryParse(value)),
        ),
      FilterOperation.between => _BetweenFilterWidget<int>(
          onValueChanged: (values) => onValueChanged(values),
          parseValue: (value) => int.tryParse(value),
          inputType: TextInputType.number,
          startLabel: localization.startValue,
          endLabel: localization.endValue,
        ),
      _ => throw UnsupportedError('Unsupported operation for numbers'),
    };
  }
}

class DoubleNumberFilterWidgetBuilder extends FilterWidgetBuilder {
  final BuildContext context;

  DoubleNumberFilterWidgetBuilder({required this.context});

  @override
  Widget build(
      FilterOperation operation, void Function(dynamic value) onValueChanged) {
    final localization = AppLocalizations.of(context)!;
    switch (operation) {
      case FilterOperation.eq:
      case FilterOperation.lt:
      case FilterOperation.gt:
        return TextField(
          decoration: InputDecoration(
            labelText:
                '${localization.enterValue} (${localization.translateOperationName(operation)})',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => onValueChanged(double.tryParse(value)),
        );
      case FilterOperation.between:
        return _BetweenFilterWidget<double>(
          onValueChanged: (values) => onValueChanged(values),
          parseValue: (value) => double.tryParse(value),
          inputType: TextInputType.number,
          startLabel: localization.startValue,
          endLabel: localization.endValue,
        );
      default:
        throw UnsupportedError('Unsupported operation for numbers');
    }
  }
}

class StringFilterWidgetBuilder extends FilterWidgetBuilder {
  final BuildContext context;

  StringFilterWidgetBuilder({required this.context});

  @override
  Widget build(
      FilterOperation operation, void Function(dynamic value) onValueChanged) {
    final localization = AppLocalizations.of(context)!;
    switch (operation) {
      case FilterOperation.eq:
      case FilterOperation.like:
        return TextField(
          decoration: InputDecoration(
              labelText:
                  '${localization.enterValue} (${localization.translateOperationName(operation)})'),
          onChanged: onValueChanged,
        );
      default:
        throw UnsupportedError('Unsupported operation for strings');
    }
  }
}

class DateFilterWidgetBuilder extends FilterWidgetBuilder {
  final BuildContext context;
  final TextEditingController dateController = TextEditingController();

  DateFilterWidgetBuilder({required this.context});

  @override
  Widget build(
      FilterOperation operation, void Function(dynamic value) onValueChanged) {
    final localization = AppLocalizations.of(context)!;

    return switch (operation) {
      FilterOperation.eq ||
      FilterOperation.lt ||
      FilterOperation.gt =>
        TextField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText:
                '${localization.selectDate} (${localization.translateOperationName(operation)})',
            hintText: localization.selectDate,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          onTap: () async {
            // Open the date picker
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              // Format and display the selected date
              final formattedDate = pickedDate.forceFormatToDate();
              dateController.text = formattedDate;

              // Pass ISO string to the callback
              onValueChanged(pickedDate.toIso8601String());
            }
          },
        ),
      FilterOperation.between => _BetweenFilterWidget<DateTime>(
          onValueChanged: (values) => onValueChanged(values),
          parseValue: (value) => DateTime.tryParse(value),
          isDate: true,
          startLabel: localization.startDate,
          endLabel: localization.endDate,
        ),
      _ => throw UnsupportedError('Unsupported operation for dates'),
    };
  }
}

class _BetweenFilterWidget<T> extends StatefulWidget {
  final void Function(List<T?> value) onValueChanged;
  final T? Function(String value) parseValue;
  final String startLabel;
  final String endLabel;
  final TextInputType? inputType;
  final bool isDate;

  const _BetweenFilterWidget({
    required this.onValueChanged,
    required this.parseValue,
    required this.startLabel,
    required this.endLabel,
    this.inputType,
    this.isDate = false,
    super.key,
  });

  @override
  State<_BetweenFilterWidget<T>> createState() =>
      _BetweenFilterWidgetState<T>();
}

class _BetweenFilterWidgetState<T> extends State<_BetweenFilterWidget<T>> {
  T? startValue;
  T? endValue;

  late final TextEditingController startController;
  late final TextEditingController endController;

  String? startErrorText;
  String? endErrorText;

  @override
  void initState() {
    super.initState();
    startController = TextEditingController();
    endController = TextEditingController();
  }

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final formattedDate = pickedDate.forceFormatToDate();
      setState(() {
        if (isStart) {
          startValue = pickedDate as T?;
          startController.text = formattedDate;
          startErrorText = null; // Clear error
        } else {
          endValue = pickedDate as T?;
          endController.text = formattedDate;
          endErrorText = null; // Clear error
        }
      });
      _validateAndUpdateValues();
    }
  }

  void _validateAndUpdateValues() {
    setState(() {
      startErrorText =
          startValue == null ? 'Please select a start date.' : null;
      endErrorText = endValue == null ? 'Please select an end date.' : null;
    });

    if (startValue != null && endValue != null) {
      widget.onValueChanged([startValue, endValue]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Start field
        widget.isDate
            ? TextField(
                controller: startController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: widget.startLabel,
                  hintText: widget.startLabel,
                  suffixIcon: const Icon(Icons.calendar_today),
                  errorText: startErrorText, // Display error if needed
                ),
                onTap: () => _pickDate(true),
              )
            : TextField(
                decoration: InputDecoration(
                  labelText: widget.startLabel,
                  errorText: startErrorText, // Display error if needed
                ),
                keyboardType: widget.inputType,
                onChanged: (value) {
                  setState(() {
                    startValue = widget.parseValue(value);
                    startErrorText = null; // Clear error
                  });
                  _validateAndUpdateValues();
                },
              ),
        // End field
        widget.isDate
            ? TextField(
                controller: endController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: widget.endLabel,
                  hintText: widget.endLabel,
                  suffixIcon: const Icon(Icons.calendar_today),
                  errorText: endErrorText, // Display error if needed
                ),
                onTap: () => _pickDate(false),
              )
            : TextField(
                decoration: InputDecoration(
                  labelText: widget.endLabel,
                  errorText: endErrorText, // Display error if needed
                ),
                keyboardType: widget.inputType,
                onChanged: (value) {
                  setState(() {
                    endValue = widget.parseValue(value);
                    endErrorText = null; // Clear error
                  });
                  _validateAndUpdateValues();
                },
              ),
      ],
    );
  }
}
