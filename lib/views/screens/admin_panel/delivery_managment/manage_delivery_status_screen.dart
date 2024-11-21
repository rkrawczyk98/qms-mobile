import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_status_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/screens/admin_panel/delivery_managment/edit_delivery_status_screen.dart';

class ManageDeliveryStatusesScreen extends ConsumerWidget {
  const ManageDeliveryStatusesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryStatusesAsync = ref.watch(deliveryStatusProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.manageDeliveryStatuses),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              try {
                await ref.read(deliveryStatusProvider.notifier).fetchDeliveryStatuses();
                CustomSnackbar.showSuccessSnackbar(
                  context,
                  localizations.refreshSuccess,
                );
              } catch (e) {
                CustomSnackbar.showErrorSnackbar(
                  context,
                  localizations.refreshError,
                );
              }
            },
          ),
        ],
      ),
      body: deliveryStatusesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(localizations.fetchErrorDeliveryStatuses),
        ),
        data: (statuses) {
          if (statuses.isEmpty) {
            return Center(child: Text(localizations.noDeliveryStatusesAvailable));
          }
          return ListView.builder(
            itemCount: statuses.length,
            itemBuilder: (context, index) {
              final status = statuses[index];
              return ListTile(
                title: Text(status.name),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditDeliveryStatusScreen(
                              statusId: status.id,
                              initialName: status.name,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDeleteDeliveryStatus(
                          context,
                          ref,
                          status.id,
                          status.name,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDeleteDeliveryStatus(BuildContext context, WidgetRef ref,
      int statusId, String statusName) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.confirmDelete),
          content: Text('${localizations.confirmDeleteDeliveryStatus} "$statusName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localizations.cancel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(deliveryStatusProvider.notifier)
                      .deleteDeliveryStatus(statusId);
                  CustomSnackbar.showSuccessSnackbar(
                    context,
                    localizations.deliveryStatusDeletedSuccess,
                  );
                } catch (e) {
                  CustomSnackbar.showErrorSnackbar(
                    context,
                    localizations.deliveryStatusDeleteError,
                  );
                }
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                localizations.delete,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }
}
