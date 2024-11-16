import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/providers/warehouse_module/warehouse_position_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/screens/admin_panel/warehouse_managment/edit_warehouse_position_screen.dart';

class ManageWarehousePositionsScreen extends ConsumerWidget {
  const ManageWarehousePositionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positions = ref.watch(warehousePositionProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.manageWarehousePositions),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await ref
                  .read(warehousePositionProvider.notifier)
                  .fetchWarehousePositions();
              CustomSnackbar.showSuccessSnackbar(
                context,
                localizations.refreshSuccess,
              );
            },
          ),
        ],
      ),
      body: positions.isEmpty
          ? Center(child: Text(localizations.noWarehousePositionsAvailable))
          : ListView.builder(
              itemCount: positions.length,
              itemBuilder: (context, index) {
                final position = positions[index];
                return ListTile(
                  title: Text(position.name),
                  subtitle: Text(
                      '${localizations.warehouseID}: ${position.warehouseId}'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditWarehousePositionScreen(
                                position: position,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeletePosition(context, ref, position.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _confirmDeletePosition(BuildContext context, WidgetRef ref, int id) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.confirmDelete),
          content:
              Text('${localizations.confirmDeleteWarehousePosition} "$id"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.cancel,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            TextButton(
              onPressed: () async {
                await ref
                    .read(warehousePositionProvider.notifier)
                    .deleteWarehousePosition(id);
                CustomSnackbar.showSuccessSnackbar(
                    context, localizations.warehousePositionDeletedSuccess);
                Navigator.pop(context); // Close dialog
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
