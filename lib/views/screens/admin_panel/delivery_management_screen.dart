import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryManagementScreen extends StatelessWidget {
  const DeliveryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.deliveryManagementTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(localizations.addDelivery),
            onTap: () {
              // TODO: Add functionality to add delivery
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(localizations.editDelivery),
            onTap: () {
              // TODO: Add functionality to edit delivery
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(localizations.deleteDelivery),
            onTap: () {
              // TODO: Add functionality to delete delivery
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_fix_high),
            title: Text(localizations.manageAutoStatuses),
            onTap: () {
              // TODO: Add functionality to manage automatic statuses
            },
          ),
        ],
      ),
    );
  }
}
