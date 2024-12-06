import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart'; // Dodaj tę linię, aby użyć `firstWhereOrNull`
import 'package:qms_mobile/data/models/DTOs/component_module/component/component_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_subcomponent/update_component_subcomponent_dto.dart';
import 'package:qms_mobile/data/providers/component_module/component_provider.dart';
import 'package:qms_mobile/data/providers/component_module/component_subcomponent_provider.dart';
import 'package:qms_mobile/data/providers/component_module/subcomponent_provider.dart';
import 'package:qms_mobile/data/providers/component_module/subcomponent_status_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComponentManageScreen extends ConsumerStatefulWidget {
  final int componentId;

  const ComponentManageScreen({super.key, required this.componentId});

  @override
  ConsumerState<ComponentManageScreen> createState() =>
      _ComponentDetailsScreenState();
}

class _ComponentDetailsScreenState
    extends ConsumerState<ComponentManageScreen> {
  late AsyncValue<ComponentResponseDto?> component;

  @override
  void initState() {
    super.initState();
    _fetchComponentData();
  }

  Future<void> _fetchComponentData() async {
    await Future.wait([
      ref.read(componentSubcomponentProvider.notifier).fetchComponentSubcomponents(),
      ref.read(subcomponentProvider.notifier).fetchAllSubcomponents(),
      ref.read(subcomponentStatusProvider.notifier).fetchAllStatuses(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final componentsAsync = ref.watch(componentProvider);

    return componentsAsync.when(
      data: (components) {
        final component = components.firstWhereOrNull((c) => c.id == widget.componentId);

        if (component == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(localization.componentDetails),
            ),
            body: Center(
              child: Text(localization.componentNotFound),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(localization.componentDetails),
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
                _buildComponentInfo(context, component),
                const SizedBox(height: 16),
                _buildSubcomponentsList(context, component),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: Text(localization.componentDetails),
        ),
        body: Center(
          child: Text(localization.unknownError),
        ),
      ),
    );
  }

  Widget _buildComponentInfo(BuildContext context, ComponentResponseDto component) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.componentInfo,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text('${localization.name}: ${component.nameOne}'),
        Text('${localization.type}: ${component.componentType.name}'),
        Text('${localization.status}: ${component.status.name}'),
        Text('${localization.createdBy}: ${component.createdByUser.username}'),
        Text('${localization.size}: ${component.size}'),
        if (component.productionDate != null)
          Text(
            '${localization.productionDate}: ${component.productionDate}',
          ),
        if (component.controlDate != null)
          Text(
            '${localization.controlDate}: ${component.controlDate}',
          ),
      ],
    );
  }

  Widget _buildSubcomponentsList(
      BuildContext context, ComponentResponseDto component) {
    final localization = AppLocalizations.of(context)!;
    final componentSubcomponents = ref
        .watch(componentSubcomponentProvider)
        .maybeWhen(
          data: (subcomponents) =>
              subcomponents.where((cs) => cs.componentId == component.id).toList(),
          orElse: () => [],
        );
    final subcomponents = ref.watch(subcomponentProvider).maybeWhen(
          data: (subs) => subs,
          orElse: () => [],
        );
    final statuses = ref.watch(subcomponentStatusProvider).maybeWhen(
          data: (stats) => stats,
          orElse: () => [],
        );

    if (componentSubcomponents.isEmpty) {
      return Text(localization.noSubcomponents);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.subcomponents,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        ...componentSubcomponents.map((componentSubcomponent) {
          final subcomponent = subcomponents.firstWhereOrNull(
              (sub) => sub.id == componentSubcomponent.subcomponentId);
          final status = statuses.firstWhereOrNull(
              (stat) => stat.id == componentSubcomponent.statusId);

          if (subcomponent == null || status == null) {
            return const SizedBox.shrink();
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.extension),
              title: Text(subcomponent.name),
              trailing: DropdownButton<int>(
                value: componentSubcomponent.statusId,
                onChanged: (newValue) {
                  if (newValue != null) {
                    _updateSubcomponentStatus(
                      componentSubcomponent.id,
                      newValue,
                    );
                  }
                },
                items: statuses.map((status) {
                  return DropdownMenuItem<int>(
                    value: status.id,
                    child: Text(status.name),
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _updateSubcomponentStatus(
      int subcomponentId, int newStatusId) async {
    try {
      if (!mounted) return;
      await ref
          .read(componentSubcomponentProvider.notifier)
          .updateComponentSubcomponent(
            subcomponentId,
            UpdateComponentSubcomponentDto(statusId: newStatusId),
          );

      if (!mounted) return;
      CustomSnackbar.showSuccessSnackbar(
        context,
        AppLocalizations.of(context)!.statusUpdatedSuccessfully,
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showErrorSnackbar(
        context,
        AppLocalizations.of(context)!.statusUpdateError,
      );
    }
  }
}
