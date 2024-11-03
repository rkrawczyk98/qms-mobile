import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.userManagement)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person_add),
            title: Text(localizations.addUser),
            onTap: () {
              // Logika dodawania użytkownika
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(localizations.manageRolesPermissions),
            onTap: () {
              // Logika zarządzania rolami i uprawnieniami
            },
          ),
        ],
      ),
    );
  }
}
