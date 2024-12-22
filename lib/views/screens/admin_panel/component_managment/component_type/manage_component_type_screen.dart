import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/component_type_response_dto.dart';
import 'package:qms_mobile/data/providers/component_module/component_type_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';

class ManageComponentTypesScreen extends ConsumerWidget {
  const ManageComponentTypesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final componentTypesAsync = ref.watch(componentTypeProvider);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.manageComponentTypes),
      ),
      body: componentTypesAsync.when(
        data: (componentTypes) {
          if (componentTypes.isEmpty) {
            return Center(
              child: Text(localization.noComponentTypes),
            );
          }
          return ListView.builder(
            itemCount: componentTypes.length,
            itemBuilder: (context, index) {
              final componentType = componentTypes[index];
              final isActive = componentType.deletedAt == null;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(componentType.name),
                  subtitle: Text(isActive
                      ? localization.activeStatus
                      : localization.inactiveStatus),
                  onTap: () {
                    // Navigate to the edit screen on tap
                    navigationService.navigateTo(
                      AppRoutes.editComponentType,
                      arguments: componentType.id,
                    );
                  },
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      // if (value == 'edit') {
                      //   navigationService.navigateTo(
                      //     AppRoutes.editComponentType,
                      //     arguments: componentType.id,
                      //   );
                      // } else 
                      if (value == 'toggle') {
                        _confirmToggleStatus(
                          context,
                          ref,
                          componentType,
                          isActive,
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      // PopupMenuItem(
                      //   value: 'edit',
                      //   child: Text(localization.edit),
                      // ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(
                          isActive
                              ? localization.deactivate
                              : localization.activate,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(localization.errorLoadingComponentTypes),
        ),
      ),
    );
  }

  void _confirmToggleStatus(
    BuildContext context,
    WidgetRef ref,
    ComponentTypeResponseDto componentType,
    bool isActive,
  ) {
    final localization = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isActive
                ? localization.deactivateComponentType
                : localization.activateComponentType,
          ),
          content: Text(
            isActive
                ? localization.deactivateComponentTypeConfirm
                : localization.activateComponentTypeConfirm,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localization.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final updatedComponentType = componentType.copyWith(
                  deletedAt: isActive ? DateTime.now() : null,
                );
                ref
                    .read(componentTypeProvider.notifier)
                    .updateComponentType(componentType.id, updatedComponentType);
              },
              child: Text(localization.confirm),
            ),
          ],
        );
      },
    );
  }
}
