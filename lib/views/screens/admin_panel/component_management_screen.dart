import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComponentManagementScreen extends StatelessWidget {
  const ComponentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.componentManagementTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(localizations.addComponentType),
            onTap: () {
              // TODO: Add functionality to add component type
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(localizations.editComponentType),
            onTap: () {
              // TODO: Add functionality to edit component type
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(localizations.deleteComponentType),
            onTap: () {
              // TODO: Add functionality to delete component type
            },
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(localizations.manageSubcomponents),
            onTap: () {
              // TODO: Add functionality to manage subcomponents
            },
          ),
        ],
      ),
    );
  }
}
