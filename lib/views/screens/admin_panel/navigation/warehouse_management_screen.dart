import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';

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
              navigationService.navigateTo(AppRoutes.createWarehouse);
            },
          ),
          ListTile(
            leading: const Icon(Icons.warehouse),
            title: Text(localizations.manageWarehouses),
            onTap: () {
              navigationService.navigateTo(AppRoutes.manageWarehouse);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_location_alt),
            title: Text(localizations.addWarehousePosition),
            onTap: () {
              navigationService.navigateTo(AppRoutes.createWarehousePosition);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(localizations.manageWarehousePositions),
            onTap: () {
              navigationService.navigateTo(AppRoutes.manageWarehousePosition);
            },
          ),
        ],
      ),
    );
  }
}
