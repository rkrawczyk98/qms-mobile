import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.inventoryManagementTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(localizations.addInventory),
            onTap: () {
              // TODO: Add functionality to add inventory
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(localizations.editInventory),
            onTap: () {
              // TODO: Add functionality to edit inventory
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(localizations.deleteInventory),
            onTap: () {
              // TODO: Add functionality to delete inventory
            },
          ),
        ],
      ),
    );
  }
}
