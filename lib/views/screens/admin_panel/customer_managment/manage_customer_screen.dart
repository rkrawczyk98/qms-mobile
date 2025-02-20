import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/providers/customer_module/customer_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/screens/admin_panel/customer_managment/edit_customer_sceen.dart';

class ManageCustomersScreen extends ConsumerWidget {
  const ManageCustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customerProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.manageCustomers),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              try {
                await ref.read(customerProvider.notifier).fetchCustomers();
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
      body: customersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(localizations.fetchErrorCustomers),
        ),
        data: (customers) {
          if (customers.isEmpty) {
            return Center(child: Text(localizations.noCustomersAvailable));
          }
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ListTile(
                title: Text(customer.name),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditCustomerScreen(
                              customerId: customer.id,
                              initialName: customer.name,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDeleteCustomer(
                          context,
                          ref,
                          customer.id,
                          customer.name,
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

  void _confirmDeleteCustomer(BuildContext context, WidgetRef ref,
      int customerId, String customerName) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.confirmDelete),
          content:
              Text('${localizations.confirmDeleteCustomer} "$customerName"?'),
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
                      .read(customerProvider.notifier)
                      .deleteCustomer(customerId);
                  CustomSnackbar.showSuccessSnackbar(
                    context,
                    localizations.customerDeletedSuccess,
                  );
                } catch (e) {
                  CustomSnackbar.showErrorSnackbar(
                    context,
                    localizations.customerDeleteError,
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
