import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';

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
              navigationService.navigateTo(AppRoutes.createUser);
            },
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: Text(localizations.manageUsers),
            onTap: () {
              navigationService.navigateTo(AppRoutes.manageUser);
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: Text(localizations.manageRolesPermissions),
            onTap: () {
              navigationService.navigateTo(AppRoutes.rolePermissionManagment);
            },
          ),
        ],
      ),
    );
  }
}
