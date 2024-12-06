import 'package:flutter/material.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/delivery_response_dto.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/views/widgets/info_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/utils/externsions/date_formater_extensions.dart';

class DeliveryList extends StatelessWidget {
  final List<DeliveryResponseDto> deliveries;

  const DeliveryList({super.key, required this.deliveries});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      itemCount: deliveries.length,
      itemBuilder: (context, index) {
        final delivery = deliveries[index];
        return InfoCard(
          title: delivery.number,
          titleLabel: localizations.deliveryNumber,
          icon: const Icon(
            Icons.local_shipping_outlined,
            size: 35,
            color: Colors.blue,
          ),
          fields: {
            localizations.componentType: delivery.componentType?.name,
            localizations.status: delivery.status?.name,
            localizations.customer: delivery.customer?.name,
            localizations.lastModified:
                delivery.lastModified.formatToDateTime(),
          },
          onRightTap: () {
            navigationService.navigateTo(
              AppRoutes.deliveryContents,
              arguments: delivery.id,
            );
          },
          onLeftTap: () {
            navigationService.navigateTo(
              AppRoutes.deliveryDetails,
              arguments: delivery.id,
            );
          },
          leadingColor: Colors.blue,
          leftTapText: localizations.details,
          rightTapText: localizations.contents,
        );
      },
    );
  }
}
