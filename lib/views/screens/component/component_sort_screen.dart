import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComponentSortScreen extends StatefulWidget {
  final String? initialSortColumn;
  final String initialSortOrder;

  const ComponentSortScreen({
    this.initialSortColumn,
    this.initialSortOrder = 'ASC',
    super.key,
  });

  @override
  State<ComponentSortScreen> createState() => _ComponentSortScreenState();
}

class SortField {
  final String databaseName;

  SortField({required this.databaseName});
}

class _ComponentSortScreenState extends State<ComponentSortScreen> {
  late String? sortColumn;
  late String sortOrder;

  late final List<SortField> sortFields;

  @override
  void initState() {
    super.initState();
    sortColumn = widget.initialSortColumn;
    sortOrder = widget.initialSortOrder;

    sortFields = [
      SortField(databaseName: 'component.id'),
      SortField(databaseName: 'component.insideNumber'),
      SortField(databaseName: 'component.outsideNumber'),
      SortField(databaseName: 'component.nameOne'),
      SortField(databaseName: 'component.size'),
      SortField(databaseName: 'component.productionDate'),
      SortField(databaseName: 'component.controlDate'),
      SortField(databaseName: 'component.shippingDate'),
      SortField(databaseName: 'component.creationDate'),
      SortField(databaseName: 'component.lastModified'),
      SortField(databaseName: 'createdByUser.username'),
      SortField(databaseName: 'componentModifiedByUser.username'),
      SortField(databaseName: 'componentType.name'),
    ];
  }

  void _applySort() {
    Navigator.pop(context, {'column': sortColumn, 'order': sortOrder});
  }

  void _resetSort() {
    setState(() {
      sortColumn = 'component.insideNumber'; // Resetting the sort column
      sortOrder = 'ASC'; // Restore default sort direction
    });
  }

  String _translateFieldName(String key, AppLocalizations localization) {
    switch (key) {
      case 'component.id':
        return localization.id;
      case 'component.insideNumber':
        return localization.insideNumber;
      case 'component.outsideNumber':
        return localization.outsideNumber;
      case 'component.nameOne':
        return localization.name;
      case 'component.size':
        return localization.size;
      case 'component.productionDate':
        return localization.productionDate;
      case 'component.controlDate':
        return localization.controlDate;
      case 'component.shippingDate':
        return localization.shippingDate;
      case 'component.creationDate':
        return localization.creationDate;
      case 'component.lastModified':
        return localization.lastModified;
      case 'createdByUser.username':
        return localization.createdByUsername;
      case 'componentModifiedByUser.username':
        return localization.modifiedByUsername;
      case 'componentType.name':
        return localization.componentTypeName;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.sortComponents),
        actions: [
        TextButton(
          onPressed: _resetSort,
          child: Text(
            localization.clear,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localization.sortComponents,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sort Column Dropdown
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: localization.selectColumn,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: sortColumn,
                        isExpanded: true,
                        items: sortFields.map((field) {
                          return DropdownMenuItem(
                            value: field.databaseName,
                            child: Text(_translateFieldName(
                                field.databaseName, localization)),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => sortColumn = value),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sort Order Dropdown
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: localization.selectedOrder,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: sortOrder,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                              value: 'ASC',
                              child: Text(localization.ascending)),
                          DropdownMenuItem(
                              value: 'DESC',
                              child: Text(localization.descending)),
                        ],
                        onChanged: (value) =>
                            setState(() => sortOrder = value!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _applySort,
                    child: Text(localization.apply),
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
