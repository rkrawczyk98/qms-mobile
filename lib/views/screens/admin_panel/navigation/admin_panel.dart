import 'package:flutter/material.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.adminPanel)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(localizations.userManagement),
            onTap: () => navigationService.navigateTo(AppRoutes.userManagement),
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text(localizations.deliveryManagement),
            onTap: () => navigationService.navigateTo(AppRoutes.deliveryManagement),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: Text(localizations.customerManagement),
            onTap: () => navigationService.navigateTo(AppRoutes.customerManagement),
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: Text(localizations.componentManagement),
            onTap: () => navigationService.navigateTo(AppRoutes.componentManagement),
          ),
          ListTile(
            leading: const Icon(Icons.warehouse),
            title: Text(localizations.warehouseManagement),
            onTap: () => navigationService.navigateTo(AppRoutes.warehouseManagement),
          ),
        ],
      ),
    );
  }
}
