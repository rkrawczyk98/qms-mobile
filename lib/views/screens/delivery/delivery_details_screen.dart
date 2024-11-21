import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/delivery_response_dto.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_provider.dart';
import 'package:qms_mobile/utils/formatters/date_formater.dart';

class DeliveryDetailsScreen extends ConsumerWidget {
  final int deliveryId;

  const DeliveryDetailsScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final deliveryNotifier = ref.read(deliveryProvider.notifier);

    return FutureBuilder(
      future: deliveryNotifier.getDeliveryById(deliveryId),
      builder: (context, AsyncSnapshot<DeliveryResponseDto?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(localization.deliveryDetailsTitle),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(localization.deliveryDetailsTitle),
            ),
            body: Center(
              child: Text(
                localization.errorLoadingDelivery,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final delivery = snapshot.data;
        if (delivery == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(localization.deliveryDetailsTitle),
            ),
            body: Center(
              child: Text(localization.deliveryNotFound),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(localization.deliveryDetailsTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  deliveryNotifier.getDeliveryById(deliveryId);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DeliveryInfo(
                  number: delivery.number,
                  status: delivery.status?.name ?? localization.unknown,
                  statusDate: formatDate(delivery.deliveryDate),
                  client: delivery.customer?.name ?? localization.unknown,
                  deliveryDate: formatDate(delivery.creationDate),
                  createdByUser:
                      delivery.createdByUser?.username ?? localization.unknown,
                  componentType:
                      delivery.componentType?.name ?? localization.unknown,
                ),
                const SizedBox(height: 16),
                Text(
                  localization.deliveryHistoryTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                // Expanded widget for delivery history
                // Expanded(
                //   child: delivery.history?.isNotEmpty ?? false
                //       ? ListView.builder(
                //           itemCount: delivery.history!.length,
                //           itemBuilder: (context, index) {
                //             final historyItem = delivery.history![index];
                //             return DeliveryHistoryItem(
                //               status: historyItem.status.name,
                //               date: formatDate(historyItem.date),
                //               icon: Icons.check_circle,
                //               iconColor: Colors.green,
                //             );
                //           },
                //         )
                //       : Center(child: Text(localization.noDeliveryHistory)),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DeliveryInfo extends StatelessWidget {
  final String number;
  final String status;
  final String statusDate;
  final String client;
  final String deliveryDate;
  final String createdByUser;
  final String componentType;

  const DeliveryInfo({
    super.key,
    required this.number,
    required this.status,
    required this.statusDate,
    required this.client,
    required this.deliveryDate,
    required this.createdByUser,
    required this.componentType,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(localization.deliveryNumber, number,
                localization.componentType, componentType),
            const SizedBox(height: 16),
            _buildRow(localization.status, status, localization.client, client),
            const SizedBox(height: 16),
            _buildRow(localization.deliveryDate, deliveryDate,
                localization.createdByUser, createdByUser),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String leftTitle, String leftValue, String rightTitle,
      String rightValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildColumn(leftTitle, leftValue),
        _buildColumn(rightTitle, rightValue, alignRight: true),
      ],
    );
  }

  Widget _buildColumn(String title, String value, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class DeliveryHistoryItem extends StatelessWidget {
  final String status;
  final String date;
  final IconData icon;
  final Color iconColor;

  const DeliveryHistoryItem({
    super.key,
    required this.status,
    required this.date,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Icon(icon, color: iconColor),
            Container(
              width: 2,
              height: 50,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
