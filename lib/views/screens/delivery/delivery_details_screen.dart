import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/delivery_response_dto.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_provider.dart';
import 'package:qms_mobile/utils/externsions/date_formater_extensions.dart';
import 'package:qms_mobile/views/widgets/info_card.dart';

class DeliveryDetailsScreen extends ConsumerWidget {
  final int deliveryId;

  const DeliveryDetailsScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final deliveryNotifier = ref.read(deliveryProvider.notifier);

    return FutureBuilder<DeliveryResponseDto?>(
      future: deliveryNotifier.getDeliveryById(deliveryId),
      builder: (context, snapshot) {
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  title: delivery.number,
                  titleLabel: localization.deliveryNumber,
                  fields: {
                    localization.status: delivery.status?.name ?? localization.unknown,
                    localization.deliveryStatus: delivery.deliveryDate.formatToDateTime()!,
                    localization.client: delivery.customer?.name ?? localization.unknown,
                    localization.deliveryDate: delivery.creationDate.formatToDateTime()!,
                    localization.createdByUser: delivery.createdByUser?.username ?? localization.unknown,
                    localization.componentType: delivery.componentType?.name ?? localization.unknown,
                    localization.lastModified: delivery.lastModified.formatToDateTime(),
                  },
                  icon: const Icon(Icons.local_shipping, color: Colors.blue, size: 35),
                  leadingColor: Colors.blue,
                  leftTapText: localization.edit,
                  rightTapText: localization.manage,
                  showTabButtons: false,
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
                Center(
                  child: Text(
                    localization.noDeliveryHistory,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}