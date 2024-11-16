import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/providers/warehouse_module/warehouse_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/screens/admin_panel/warehouse_managment/edit_warehouse_screen.dart';

class ManageWarehousesScreen extends ConsumerWidget {
  const ManageWarehousesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehouses = ref.watch(warehouseProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.manageWarehouses),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await ref.read(warehouseProvider.notifier).fetchWarehouses();
              CustomSnackbar.showSuccessSnackbar(
                context,
                localizations.refreshSuccess,
              );
            },
          ),
        ],
      ),
      body: warehouses.isEmpty
          ? Center(child: Text(localizations.noWarehousesAvailable))
          : ListView.builder(
              itemCount: warehouses.length,
              itemBuilder: (context, index) {
                final warehouse = warehouses[index];
                return ListTile(
                  title: Text(warehouse.name),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditWarehouseScreen(
                                warehouseId: warehouse.id,
                                initialName: warehouse.name,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeleteWarehouse(
                              context, ref, warehouse.id, warehouse.name);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _confirmDeleteWarehouse(BuildContext context, WidgetRef ref,
      int warehouseId, String warehouseName) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.confirmDelete),
          content:
              Text('${localizations.confirmDeleteWarehouse} "$warehouseName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.cancel,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            TextButton(
              onPressed: () async {
                await ref
                    .read(warehouseProvider.notifier)
                    .deleteWarehouse(warehouseId);
                CustomSnackbar.showSuccessSnackbar(
                    context, localizations.warehouseDeletedSuccess);
                Navigator.pop(context); // Close the dialog
              },
              child: Text(localizations.delete,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        );
      },
    );
  }
}
