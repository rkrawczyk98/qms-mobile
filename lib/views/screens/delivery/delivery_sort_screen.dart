import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliverySortScreen extends StatefulWidget {
  final String? initialSortColumn;
  final String initialSortOrder;

  const DeliverySortScreen({
    this.initialSortColumn,
    this.initialSortOrder = 'ASC',
    super.key,
  });

  @override
  State<DeliverySortScreen> createState() => _DeliverySortScreenState();
}

class SortField {
  final String databaseName;

  SortField({required this.databaseName});
}

class _DeliverySortScreenState extends State<DeliverySortScreen> {
  late String? sortColumn;
  late String sortOrder;

  late final List<SortField> sortFields;

  @override
  void initState() {
    super.initState();
    sortColumn = widget.initialSortColumn;
    sortOrder = widget.initialSortOrder;

    sortFields = [
      SortField(databaseName: 'delivery.id'),
      SortField(databaseName: 'delivery.number'),
      SortField(databaseName: 'delivery.deliveryDate'),
      SortField(databaseName: 'delivery.creationDate'),
      SortField(databaseName: 'delivery.lastModified'),
      SortField(databaseName: 'status.name'),
      SortField(databaseName: 'customer.name'),
      SortField(databaseName: 'createdByUser.username'),
      SortField(databaseName: 'componentType.name'),
    ];
  }

  void _applySort() {
    Navigator.pop(context, {'column': sortColumn, 'order': sortOrder});
  }

  void _resetSort() {
    setState(() {
      sortColumn = 'delivery.number'; // Resetting the sort column
      sortOrder = 'ASC'; // Restore default sort direction
    });
  }

  String _translateFieldName(String key, AppLocalizations localization) {
    switch (key) {
      case 'delivery.id':
        return localization.id;
      case 'delivery.number':
        return localization.deliveryNumber;
      case 'delivery.deliveryDate':
        return localization.deliveryDate;
      case 'delivery.creationDate':
        return localization.creationDate;
      case 'delivery.lastModified':
        return localization.lastModified;
      case 'status.name':
        return localization.statusName;
      case 'customer.name':
        return localization.customerName;
      case 'createdByUser.username':
        return localization.createdByUsername;
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
        title: Text(localization.sortDeliveries),
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
                    localization.sortDeliveries,
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
