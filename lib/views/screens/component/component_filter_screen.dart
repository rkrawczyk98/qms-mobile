import 'package:flutter/material.dart';
import 'package:qms_mobile/utils/helpers/component/filter_operation.dart';

class ComponentFilterScreen extends StatefulWidget {
  const ComponentFilterScreen({Key? key}) : super(key: key);

  @override
  _ComponentFilterScreenState createState() => _ComponentFilterScreenState();
}

class _ComponentFilterScreenState extends State<ComponentFilterScreen> {
  String? selectedField;
  String? selectedOperation;
  dynamic fieldValue;
  final Map<String, dynamic> appliedFilters = {};

  String buildFilterQuery(Map<String, dynamic> filters) {
    final filterStrings = filters.entries.map((entry) {
      final operation = entry.value['operation'];
      final value = entry.value['value'];
      if (operation == 'between' && value is List) {
        return '${entry.key}:$operation|${value[0]}|${value[1]}';
      }
      return '${entry.key}:$operation|$value';
    });
    return filterStrings.join(';');
  }

  void _addFilter() {
    if (selectedField != null &&
        selectedOperation != null &&
        fieldValue != null) {
      appliedFilters[selectedField!] = {
        'operation': selectedOperation,
        'value': fieldValue,
      };

      setState(() {
        selectedField = null;
        selectedOperation = null;
        fieldValue = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select field, operation, and value')),
      );
    }
  }

  void _applyFilters() {
    final filterQuery = buildFilterQuery(appliedFilters);
    Navigator.pop(context, filterQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Components'),
        actions: [
          TextButton(
            onPressed: _applyFilters,
            child: const Text('Apply', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedField,
              hint: const Text('Select Field'),
              items: filterOptions.map((config) {
                return DropdownMenuItem(
                  value: config.databaseName,
                  child: Text(config.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedField = value;
                  selectedOperation = null;
                  fieldValue = null;
                });
              },
            ),
            if (selectedField != null)
              DropdownButton<String>(
                value: selectedOperation,
                hint: const Text('Select Operation'),
                items: filterOptions
                    .firstWhere(
                        (config) => config.databaseName == selectedField)
                    .allowedFilteringOperations
                    .map((operation) => DropdownMenuItem(
                          value: operation.name,
                          child: Text(operation.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOperation = value;
                  });
                },
              ),
            if (selectedField != null && selectedOperation != null)
              filterOptions
                  .firstWhere((config) => config.databaseName == selectedField)
                  .widgetBuilder
                  .build(
                FilterOperation.values
                    .firstWhere((op) => op.name == selectedOperation),
                (value) {
                  setState(() {
                    fieldValue = value;
                  });
                },
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addFilter,
              child: const Text('Add Filter'),
            ),
            const SizedBox(height: 16),
            if (appliedFilters.isNotEmpty)
              Expanded(
                child: ListView(
                  children: appliedFilters.entries.map((entry) {
                    final field = entry.key;
                    final operation = entry.value['operation'];
                    final value = entry.value['value'];
                    return ListTile(
                      title: Text('$field $operation $value'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            appliedFilters.remove(field);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


final List<FilterOption> filterOptions = [
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
