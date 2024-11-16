import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WarehouseManagementScreen extends StatelessWidget {
  const WarehouseManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.warehouseManagementTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(localizations.addWarehouse),
            onTap: () {
              // TODO: Add functionality to add warehouse
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(localizations.editWarehouse),
            onTap: () {
              // TODO: Add functionality to edit warehouse
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(localizations.deleteWarehouse),
            onTap: () {
              // TODO: Add functionality to delete warehouse
            },
          ),
        ],
      ),
    );
  }
}
