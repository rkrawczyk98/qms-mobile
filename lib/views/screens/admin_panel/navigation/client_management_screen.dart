import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientManagementScreen extends StatelessWidget {
  const ClientManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.clientManagementTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(localizations.addClient),
            onTap: () {
              // TODO: Add functionality to add client
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(localizations.editClient),
            onTap: () {
              // TODO: Add functionality to edit client
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(localizations.deleteClient),
            onTap: () {
              // TODO: Add functionality to delete client
            },
          ),
        ],
      ),
    );
  }
}
