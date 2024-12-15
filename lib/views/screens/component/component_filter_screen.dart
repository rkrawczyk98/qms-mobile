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
  late Map<String, dynamic> appliedFilters;

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
        databaseName: 'insideNumber',
        allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
        widgetBuilder: StringFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.outsideNumber,
        objectName: 'outsideNumber',
        databaseName: 'outsideNumber',
        allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
        widgetBuilder: StringFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.name,
        objectName: 'nameOne',
        databaseName: 'nameOne',
        allowedFilteringOperations: [FilterOperation.like, FilterOperation.eq],
        widgetBuilder: StringFilterWidgetBuilder(context: context),
      ),
      FilterOption(
        displayName: localizations.size,
        objectName: 'size',
        databaseName: 'size',
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
        databaseName: 'productionDate',
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
        databaseName: 'controlDate',
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
        databaseName: 'shippingDate',
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
        formattedValue = '${(value[0] as DateTime).formatToDate()} ${localizations.and} ${(value[1] as DateTime).formatToDate()}';
      } else {
        formattedValue = DateTime.tryParse(value).forceFormatToDate();
      }
    } else if (filterOption.widgetBuilder is StringFilterWidgetBuilder) {
      formattedValue = '"$value"';
    } else {
      formattedValue = value.toString();
    }

    // Special formatting for 'between' operations
    if (operation == 'between' && value is List && value.length == 2 && formattedValue.isEmpty) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.filterComponents),
        actions: [
          TextButton(
            onPressed: _applyFilters,
            child: Text(
              AppLocalizations.of(context)!.apply,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedField,
                hint: Text(AppLocalizations.of(context)!.selectField),
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
                DropdownButton<FilterOperation>(
                  value: selectedOperation != null
                      ? FilterOperation.values
                          .firstWhere((op) => op.name == selectedOperation)
                      : null,
                  hint: Text(AppLocalizations.of(context)!.selectOperation),
                  items: filterOptions
                      .firstWhere(
                          (config) => config.databaseName == selectedField)
                      .operationMap(context)
                      .entries
                      .map((entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  onChanged: (operation) {
                    setState(() {
                      selectedOperation =
                          operation?.name; // Save original value
                    });
                  },
                ),
              if (selectedField != null && selectedOperation != null)
                filterOptions
                    .firstWhere(
                        (config) => config.databaseName == selectedField)
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
                child: Text(AppLocalizations.of(context)!.addFilter),
              ),
              const SizedBox(height: 16),
              if (appliedFilters.isNotEmpty)
                Expanded(
                  child: ListView(
                    children: appliedFilters.entries.map((entry) {
                      final field = entry.key;
                      final operation = entry.value['operation'];
                      final value = entry.value['value'];
                      final parsedFilter =
                          parseAppliedFilter(field, operation, value, context);
                      return ListTile(
                        title: Text(parsedFilter),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
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
      ),
    );
  }
}
