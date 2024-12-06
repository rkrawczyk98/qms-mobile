import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:qms_mobile/data/providers/component_module/component_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/utils/externsions/date_formater_extensions.dart';
import 'package:qms_mobile/views/screens/component/component_manage_screen.dart';
import 'package:qms_mobile/views/screens/component/component_edit_screen.dart';
import 'package:qms_mobile/views/widgets/info_card.dart';

class DeliveryContentsScreen extends ConsumerWidget {
  final int deliveryId;

  const DeliveryContentsScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch components for the given delivery
    ref.read(componentProvider.notifier);

    final components = ref.watch(componentProvider);

    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.deliveryContents),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: components.when(
        data: (data) {
          final deliveryComponents = data
              .where((component) => component.delivery.id == deliveryId)
              .toList();

          if (deliveryComponents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    localization.noComponentsForDelivery,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Column(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.add,
                              size: 50, color: Colors.blue),
                          tooltip: localization.addComponentTooltip,
                          onPressed: () => navigationService.navigateTo(
                                AppRoutes.addComponent,
                                arguments: {
                                  'showAppBar': true,
                                  'deliveryId': deliveryId
                                },
                              )),
                      Text(
                        localization.addNewComponent,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: deliveryComponents.length,
            itemBuilder: (context, index) {
              final component = deliveryComponents[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: InfoCard(
                  leadingColor: Colors.green,
                  titleLabel: localization.componentNumber,
                  title: component.nameOne,
                  icon: const Icon(Icons.view_in_ar,
                      color: Colors.green, size: 35),
                  fields: {
                    localization.type: component.componentType.name,
                    localization.status: component.status.name,
                    localization.productionDate: component.productionDate.formatNullableToDateTime(),
                    localization.controlDate: component.controlDate.formatNullableToDateTime(),
                    localization.warehouse: component.warehouse?.name,
                    localization.warehousePosition:
                        component.warehousePosition?.name,
                  },
                  onRightTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ComponentManageScreen(componentId: component.id),
                    ),
                  ),
                  onLeftTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ComponentEditScreen(componentId: component.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
            child: Text("${localization.errorLoadingComponents}: $error")),
      ),
    );
  }
}
