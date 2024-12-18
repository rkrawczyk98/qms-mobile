import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/utils/externsions/date_formater_extensions.dart';
import 'package:qms_mobile/utils/helpers/component/filter_operation.dart';

class ComponentFilterScreen extends StatefulWidget {
  final Map<String, dynamic> initialFilters;

  const ComponentFilterScreen({required this.initialFilters, super.key});

  @override
  _ComponentFilterScreenState createState() => _ComponentFilterScreenState();
}

class _ComponentFilterScreenState extends State<ComponentFilterScreen> {
  String? selectedField;
  String? selectedOperation;
  dynamic fieldValue;
  late Map<String, List<Map<String, dynamic>>> appliedFilters = {};

  late List<FilterOption> filterOptions; // Move filterOptions here

  @override
  void initState() {
    super.initState();
    appliedFilters = Map.from(widget.initialFilters); // Load saved filters
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeFilterOptions(); // Initialize filter options
  }

  void initializeFilterOptions() {
    final localizations =
        AppLocalizations.of(context); // Access AppLocalizations

    filterOptions = [
      FilterOption(
        displayName: AppLocalizations.of(context)!.id,
        objectName: 'id',
        databaseName: 'component.id',
        allowedFilteringOperations: [
          FilterOperation.eq,
          FilterOperation.lt,
          FilterOperation.gt,
          FilterOperation.between,
        ],
        widgetBuilder: IntNumberFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations!.insideNumber,
        objectName: 'insideNumber',
        databaseName: 'component.insideNumber',
        allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
        widgetBuilder: StringFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.outsideNumber,
        objectName: 'outsideNumber',
        databaseName: 'component.outsideNumber',
        allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
        widgetBuilder: StringFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.name,
        objectName: 'nameOne',
        databaseName: 'component.nameOne',
        allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
        widgetBuilder: StringFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.size,
        objectName: 'size',
        databaseName: 'component.size',
        allowedFilteringOperations: [
          FilterOperation.eq,
          FilterOperation.lt,
          FilterOperation.gt,
          FilterOperation.between,
        ],
        widgetBuilder: DoubleNumberFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.productionDate,
        objectName: 'productionDate',
        databaseName: 'component.productionDate',
        allowedFilteringOperations: [
          FilterOperation.lt,
          FilterOperation.gt,
          FilterOperation.between,
        ],
        widgetBuilder: DateFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.controlDate,
        objectName: 'controlDate',
        databaseName: 'component.controlDate',
        allowedFilteringOperations: [
          FilterOperation.lt,
          FilterOperation.gt,
          FilterOperation.between,
        ],
        widgetBuilder: DateFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.shippingDate,
        objectName: 'shippingDate',
        databaseName: 'component.shippingDate',
        allowedFilteringOperations: [
          FilterOperation.lt,
          FilterOperation.gt,
          FilterOperation.between,
        ],
        widgetBuilder: DateFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.creationDate,
        objectName: 'creationDate',
        databaseName: 'component.creationDate',
        allowedFilteringOperations: [
          FilterOperation.lt,
          FilterOperation.gt,
          FilterOperation.between,
        ],
        widgetBuilder: DateFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.lastModified,
        objectName: 'lastModified',
        databaseName: 'component.lastModified',
        allowedFilteringOperations: [
          FilterOperation.lt,
          FilterOperation.gt,
          FilterOperation.between,
        ],
        widgetBuilder: DateFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.createdByUsername,
        objectName: 'createdByUsername',
        databaseName: 'createdByUser.username',
        allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
        widgetBuilder: StringFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.modifiedByUsername,
        objectName: 'modifiedByUsername',
        databaseName: 'componentModifiedByUser.username',
        allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
        widgetBuilder: StringFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.componentTypeName,
        objectName: 'componentTypeName',
        databaseName: 'componentType.name',
        allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
        widgetBuilder: StringFilterWidgetBuilder(context: context),
      ),
    ];
  }

  String parseAppliedFilter(
      String field, String operation, dynamic value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Find the right FilterOption based on databaseName
    final filterOption =
        filterOptions.firstWhere((option) => option.databaseName == field);

    // Display field name
    final fieldName = filterOption.displayName;

    // Translating Operations
    final operationNames = {
      'eq': localizations.operationName_eq,
      'lt': localizations.operationName_lt,
      'gt': localizations.operationName_gt,
      'between': localizations.operationName_between,
      'like': localizations.operationName_like,
    };

    final operationName = operationNames[operation] ?? operation;

    // Formatting values ​​depending on widgetBuilder
    String formattedValue;
    if (filterOption.widgetBuilder is IntNumberFilterWidgetBuilder ||
        filterOption.widgetBuilder is DoubleNumberFilterWidgetBuilder) {
      formattedValue = value.toString();
    } else if (filterOption.widgetBuilder is DateFilterWidgetBuilder) {
      if (operation == 'between' && value is List && value.length == 2) {
        formattedValue =
            '${(value[0] as DateTime).formatToDate()} ${localizations.and} ${(value[1] as DateTime).formatToDate()}';
      } else {
        formattedValue = DateTime.tryParse(value).forceFormatToDate();
      }
    } else if (filterOption.widgetBuilder is StringFilterWidgetBuilder) {
      formattedValue = '"$value"';
    } else {
      formattedValue = value.toString();
    }

    // Special formatting for 'between' operations
    if (operation == 'between' &&
        value is List &&
        value.length == 2 &&
        formattedValue.isEmpty) {
      return '$fieldName $operationName ${value[0]} ${localizations.and} ${value[1]}';
    }

    // Default formatting
    return '$fieldName $operationName $formattedValue';
  }

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
      setState(() {
        // Initializing the list for the selected column
        appliedFilters.putIfAbsent(selectedField!, () => []);

        // Adding a new filter to the list
        appliedFilters[selectedField!]!.add({
          'operation': selectedOperation,
          'value': fieldValue,
        });

        // Field reset
        selectedField = null;
        selectedOperation = null;
        fieldValue = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectField),
        ),
      );
    }
  }

  void _applyFilters() {
    Navigator.pop(context, appliedFilters);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.filterComponents),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                appliedFilters.clear();
              });
            },
            child: Text(
              localization.clearFilters,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localization.filterComponents,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dropdown for selecting a field
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: localization.selectField,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedField,
                        isExpanded: true,
                        hint: Text(localization.selectField),
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dropdown for selecting an operation
                  if (selectedField != null)
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: localization.selectOperation,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<FilterOperation>(
                          value: selectedOperation != null
                              ? FilterOperation.values.firstWhere(
                                  (op) => op.name == selectedOperation)
                              : null,
                          isExpanded: true,
                          hint: Text(localization.selectOperation),
                          items: filterOptions
                              .firstWhere((config) =>
                                  config.databaseName == selectedField)
                              .operationMap(context)
                              .entries
                              .map((entry) => DropdownMenuItem(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  ))
                              .toList(),
                          onChanged: (operation) {
                            setState(() {
                              selectedOperation = operation?.name;
                            });
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Widget for value input
                  if (selectedField != null && selectedOperation != null)
                    Column(
                      children: [
                        filterOptions
                            .firstWhere((config) =>
                                config.databaseName == selectedField)
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
                      ],
                    ),
                  // Add Filter Button
                  ElevatedButton.icon(
                    onPressed: _addFilter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text(
                      localization.addFilter,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (appliedFilters.isNotEmpty)
                    Expanded(
                      child: ListView(
                        children: appliedFilters.entries.expand((entry) {
                          final field = entry.key;
                          return entry.value.map((filter) {
                            final operation = filter['operation'];
                            final value = filter['value'];
                            final parsedFilter = parseAppliedFilter(
                                field, operation, value, context);

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(parsedFilter),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      entry.value.remove(filter);
                                      if (entry.value.isEmpty) {
                                        appliedFilters.remove(field);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          });
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.check,
                        color: Colors.white),
                    label: Text(
                      localization.apply,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
