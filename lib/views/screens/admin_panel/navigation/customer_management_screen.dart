import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';

class CustomerManagementScreen extends StatelessWidget {
  const CustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.customerManagementTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(localizations.addCustomer),
            onTap: () {
              navigationService.navigateTo(AppRoutes.createCustomer);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(localizations.manageCustomers),
            onTap: () {
              navigationService.navigateTo(AppRoutes.manageCustomer);
            },
          ),
        ],
      ),
    );
  }
}
