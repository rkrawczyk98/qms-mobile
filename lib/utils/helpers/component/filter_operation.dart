import 'package:flutter/material.dart';

enum FilterOperation { eq, lt, gt, between, like }

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

  FilterOption({
    required this.displayName,
    required this.objectName,
    required this.databaseName,
    required this.allowedFilteringOperations,
    required this.widgetBuilder,
  });
}

class IntNumberFilterWidgetBuilder extends FilterWidgetBuilder {
  @override
  Widget build(
      FilterOperation operation, void Function(dynamic value) onValueChanged) {
    switch (operation) {
      case FilterOperation.eq:
      case FilterOperation.lt:
      case FilterOperation.gt:
        return TextField(
          decoration:
              InputDecoration(labelText: 'Enter value (${operation.name})'),
          keyboardType: TextInputType.number,
          onChanged: (value) => onValueChanged(int.tryParse(value)),
        );
      case FilterOperation.between:
        return _BetweenFilterWidget<int>(
          onValueChanged: (values) => onValueChanged(values),
          parseValue: (value) => int.tryParse(value),
          inputType: TextInputType.number,
        );
      default:
        throw UnsupportedError('Unsupported operation for numbers');
    }
  }
}

class DoubleNumberFilterWidgetBuilder extends FilterWidgetBuilder {
  @override
  Widget build(
      FilterOperation operation, void Function(dynamic value) onValueChanged) {
    switch (operation) {
      case FilterOperation.eq:
      case FilterOperation.lt:
      case FilterOperation.gt:
        return TextField(
          decoration:
              InputDecoration(labelText: 'Enter value (${operation.name})'),
          keyboardType: TextInputType.number,
          onChanged: (value) => onValueChanged(double.tryParse(value)),
        );
      case FilterOperation.between:
        return _BetweenFilterWidget<double>(
          onValueChanged: (values) => onValueChanged(values),
          parseValue: (value) => double.tryParse(value),
          inputType: TextInputType.number,
        );
      default:
        throw UnsupportedError('Unsupported operation for numbers');
    }
  }
}

class StringFilterWidgetBuilder extends FilterWidgetBuilder {
  @override
  Widget build(
      FilterOperation operation, void Function(dynamic value) onValueChanged) {
    switch (operation) {
      case FilterOperation.eq:
      case FilterOperation.like:
        return TextField(
          decoration:
              InputDecoration(labelText: 'Enter value (${operation.name})'),
          onChanged: onValueChanged,
        );
      default:
        throw UnsupportedError('Unsupported operation for strings');
    }
  }
}

class DateFilterWidgetBuilder extends FilterWidgetBuilder {
  @override
  Widget build(
      FilterOperation operation, void Function(dynamic value) onValueChanged) {
    switch (operation) {
      case FilterOperation.eq:
      case FilterOperation.lt:
      case FilterOperation.gt:
        return TextButton(
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: onValueChanged as BuildContext,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              onValueChanged(pickedDate.toIso8601String());
            }
          },
          child: Text('Select Date (${operation.name})'),
        );
      case FilterOperation.between:
        return _BetweenFilterWidget<DateTime>(
          onValueChanged: (values) => onValueChanged(values),
          parseValue: (value) => DateTime.tryParse(value),
          isDate: true,
        );
      default:
        throw UnsupportedError('Unsupported operation for dates');
    }
  }
}

class _BetweenFilterWidget<T> extends StatefulWidget {
  final void Function(List<T?> value) onValueChanged;
  final T? Function(String value) parseValue;
  final String startLabel;
  final String endLabel;
  final TextInputType? inputType;
  final bool isDate; // Flaga do obsługi wyboru daty

  const _BetweenFilterWidget({
    required this.onValueChanged,
    required this.parseValue,
    this.startLabel = 'Start value',
    this.endLabel = 'End value',
    this.inputType,
    this.isDate = false,
    Key? key,
  }) : super(key: key);

  @override
  State<_BetweenFilterWidget<T>> createState() =>
      _BetweenFilterWidgetState<T>();
}

class _BetweenFilterWidgetState<T> extends State<_BetweenFilterWidget<T>> {
  T? startValue;
  T? endValue;

  void _updateValues() {
    widget.onValueChanged([startValue, endValue]);
  }

  Future<void> _pickDate(bool isStart) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          startValue = pickedDate as T?;
        } else {
          endValue = pickedDate as T?;
        }
      });
      _updateValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isDate
            ? TextButton(
                onPressed: () => _pickDate(true),
                child: Text(startValue == null
                    ? widget.startLabel
                    : startValue.toString()),
              )
            : TextField(
                decoration: InputDecoration(labelText: widget.startLabel),
                keyboardType: widget.inputType,
                onChanged: (value) {
                  setState(() {
                    startValue = widget.parseValue(value);
                  });
                  _updateValues();
                },
              ),
        widget.isDate
            ? TextButton(
                onPressed: () => _pickDate(false),
                child: Text(
                    endValue == null ? widget.endLabel : endValue.toString()),
              )
            : TextField(
                decoration: InputDecoration(labelText: widget.endLabel),
                keyboardType: widget.inputType,
                onChanged: (value) {
                  setState(() {
                    endValue = widget.parseValue(value);
                  });
                  _updateValues();
                },
              ),
      ],
    );
  }
}

// Example configurations
final List<FilterOption> exampleFilterOptions = [
  FilterOption(
    displayName: 'ID',
    objectName: 'id',
    databaseName: 'component.id',
    allowedFilteringOperations: [
      FilterOperation.eq,
      FilterOperation.lt,
      FilterOperation.gt,
      FilterOperation.between
    ],
    widgetBuilder: IntNumberFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Inside Number',
    objectName: 'insideNumber',
    databaseName: 'insideNumber',
    allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
    widgetBuilder: StringFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Outside Number',
    objectName: 'outsideNumber',
    databaseName: 'outsideNumber',
    allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
    widgetBuilder: StringFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Name',
    objectName: 'nameOne',
    databaseName: 'nameOne',
    allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
    widgetBuilder: StringFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Size',
    objectName: 'size',
    databaseName: 'size',
    allowedFilteringOperations: [
      FilterOperation.eq,
      FilterOperation.lt,
      FilterOperation.gt,
      FilterOperation.between
    ],
    widgetBuilder: DoubleNumberFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Production Date',
    objectName: 'productionDate',
    databaseName: 'productionDate',
    allowedFilteringOperations: [
      FilterOperation.lt,
      FilterOperation.gt,
      FilterOperation.between
    ],
    widgetBuilder: DateFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Control Date',
    objectName: 'controlDate',
    databaseName: 'controlDate',
    allowedFilteringOperations: [
      FilterOperation.lt,
      FilterOperation.gt,
      FilterOperation.between
    ],
    widgetBuilder: DateFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Shipping Date',
    objectName: 'shippingDate',
    databaseName: 'shippingDate',
    allowedFilteringOperations: [
      FilterOperation.lt,
      FilterOperation.gt,
      FilterOperation.between
    ],
    widgetBuilder: DateFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Creation Date',
    objectName: 'creationDate',
    databaseName: 'creationDate',
    allowedFilteringOperations: [
      FilterOperation.lt,
      FilterOperation.gt,
      FilterOperation.between
    ],
    widgetBuilder: DateFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Last Modified',
    objectName: 'lastModified',
    databaseName: 'lastModified',
    allowedFilteringOperations: [
      FilterOperation.lt,
      FilterOperation.gt,
      FilterOperation.between
    ],
    widgetBuilder: DateFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Created By Username',
    objectName: 'createdByUsername',
    databaseName: 'createdByUsername',
    allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
    widgetBuilder: StringFilterWidgetBuilder(),
  ),
  // FilterOption(
  //   displayName: 'Modified By User ID',
  //   objectName: 'modifiedByUserId',
  //   databaseName: 'modifiedByUserId',
  //   allowedFilteringOperations: [FilterOperation.eq, FilterOperation.lt, FilterOperation.gt, FilterOperation.between],
  //   widgetBuilder: NumberFilterWidgetBuilder(),
  // ),
  FilterOption(
    displayName: 'Modified By Username',
    objectName: 'modifiedByUsername',
    databaseName: 'modifiedByUsername',
    allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
    widgetBuilder: StringFilterWidgetBuilder(),
  ),
  FilterOption(
    displayName: 'Component Type Name',
    objectName: 'componentTypeName',
    databaseName: 'componentTypeName',
    allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
    widgetBuilder: StringFilterWidgetBuilder(),
  ),
];
