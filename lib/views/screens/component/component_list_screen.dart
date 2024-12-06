import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/component_module/component_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/views/widgets/info_card.dart';
import 'package:qms_mobile/utils/externsions/date_formater_extensions.dart';

class ComponentList extends ConsumerWidget {
  const ComponentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final componentsAsync = ref.watch(componentProvider);

    return componentsAsync.when(
      data: (components) {
        if (components.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noComponentsFound),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: components.length,
          itemBuilder: (context, index) {
            final component = components[index];

            // Map ComponentResponseDto to InfoCard fields
            final fields = {
              AppLocalizations.of(context)!.deliveryNumber:
                  component.delivery.number,
              AppLocalizations.of(context)!.componentNumber: component.nameOne,
              AppLocalizations.of(context)!.type: component.componentType.name,
              AppLocalizations.of(context)!.status: component.status.name,
              AppLocalizations.of(context)!.productionDate:
                  component.productionDate.formatNullableToDateTime() ??
                      AppLocalizations.of(context)!.notAvailable,
              AppLocalizations.of(context)!.controlDate:
                  component.controlDate.formatNullableToDateTime() ??
                      AppLocalizations.of(context)!.notAvailable,
            };

            return InfoCard(
              title: component.nameOne,
              titleLabel: AppLocalizations.of(context)!.componentNumber,
              fields: fields,
              icon: const Icon(
                Icons.view_in_ar,
                color: Colors.green,
                size: 35,
              ),
              onRightTap: () => navigationService.navigateTo(
                AppRoutes.componentManage,
                arguments: component.id,
              ),
              onLeftTap: () => navigationService.navigateTo(
                AppRoutes.componentEdit,
                arguments: component.id,
              ),
              leadingColor: Colors.green, // Optional color customization
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(AppLocalizations.of(context)!.unknownError),
      ),
    );
  }
}
