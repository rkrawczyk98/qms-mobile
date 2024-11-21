import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/delivery_response_dto.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_provider.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/screens/delivery/add_delivery_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryScreen extends ConsumerWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesAsync = ref.watch(deliveryProvider);
    final deliveryNotifier = ref.read(deliveryProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.manageDeliveries),
          bottom: TabBar(
            tabs: [
              Tab(text: localizations.browse),
              Tab(text: localizations.create),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                try {
                  await deliveryNotifier.fetchDeliveries();
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
        body: TabBarView(
          children: [
            deliveriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('${localizations.refreshError}: $error'),
              ),
              data: (deliveries) {
                if (deliveries.isEmpty) {
                  return Center(
                    child: Text(localizations.noDeliveriesFound),
                  );
                }
                return DeliveryList(deliveries: deliveries);
              },
            ),
            const AddDeliveryScreen(),
          ],
        ),
      ),
    );
  }
}
class DeliveryList extends StatelessWidget {
  final List<DeliveryResponseDto> deliveries;

  const DeliveryList({super.key, required this.deliveries});

  @override
  Widget build(BuildContext context) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: deliveries.length,
        itemBuilder: (context, index) {
          final delivery = deliveries[index];
          return PackageItem(
            delivery: delivery,
            onDetailsTap: () {
              navigationService.navigateTo(
                AppRoutes.deliveryDetails,
                arguments: delivery.id,
              );
            },
            onContentTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DeliveryContentsScreen(
              //       deliveryId: delivery.id,
              //     ),
              //   ),
              // );
            },
          );
        },
      );
  }
}

class PackageItem extends StatelessWidget {
  final DeliveryResponseDto delivery;
  final VoidCallback onContentTap;
  final VoidCallback onDetailsTap;

  const PackageItem({
    super.key,
    required this.delivery,
    required this.onContentTap,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.deliveryNumber,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      delivery.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.local_shipping_outlined,
                color: Colors.green,
                size: 30,
              ),
            ]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.componentType,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        delivery.componentType?.name ?? 'Brak',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        localizations.status,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        delivery.status?.name ?? 'Brak',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.customer,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        delivery.customer?.name ?? 'Brak',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        localizations.lastModified,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.right,
                      ),
                      AutoSizeText(
                        delivery.lastModified.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onContentTap,
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                    child: Text(localizations.contents),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: onDetailsTap,
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                    child: Text(localizations.details),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}