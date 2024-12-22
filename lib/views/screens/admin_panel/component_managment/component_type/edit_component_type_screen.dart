import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_prefix/component_prefix_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/component_type_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent/subcomponent_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent/update_subcomponent_dto.dart';
import 'package:qms_mobile/data/providers/component_module/component_type_provider.dart';
import 'package:qms_mobile/data/providers/component_module/subcomponent_provider.dart';
import 'package:qms_mobile/data/providers/component_module/component_prefix_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reorderables/reorderables.dart';
import 'package:qms_mobile/utils/externsions/Iterable.dart';

class EditComponentTypeScreen extends ConsumerStatefulWidget {
  final int componentTypeId;

  const EditComponentTypeScreen({
    super.key,
    required this.componentTypeId,
  });

  @override
  ConsumerState<EditComponentTypeScreen> createState() =>
      _EditComponentTypeScreenState();
}

class _EditComponentTypeScreenState
    extends ConsumerState<EditComponentTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final componentTypes = ref.read(componentTypeProvider).value;
      final prefixes = ref.read(componentPrefixProvider).value;

      if (!_isInitialized && componentTypes != null && prefixes != null) {
        final componentType = componentTypes.firstWhere(
          (type) => type.id == widget.componentTypeId,
          orElse: () => throw Exception('Component type not found'),
        );
        _nameController.text = componentType.name;

        final prefix = prefixes.firstWhereOrNull(
          (p) => p.componentTypeId == widget.componentTypeId,
        );
        _prefixController.text = prefix?.prefix ?? '';
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  Future<void> _reorderSubcomponents(
      List<SubcomponentResponseDto> subcomponents,
      int oldIndex,
      int newIndex) async {
    final subcomponent = subcomponents.removeAt(oldIndex);
    subcomponents.insert(newIndex, subcomponent);

    for (int i = 0; i < subcomponents.length; i++) {
      final sub = subcomponents[i];
      final updatedSubcomponent = sub.copyWith(sortOrder: i + 1);
      await ref.read(subcomponentProvider.notifier).updateSubcomponent(
            sub.id,
            UpdateSubcomponentDto(
              name: updatedSubcomponent.name,
              componentTypeId: updatedSubcomponent.componentTypeId,
              sortOrder: updatedSubcomponent.sortOrder,
              isActivity: updatedSubcomponent.isActivity,
              deletedAt: updatedSubcomponent.deletedAt,
            ),
          );
    }
  }

  void _updateComponentType(
    ComponentTypeResponseDto componentType,
    ComponentPrefixResponseDto? prefixState,
  ) {
    final localization = AppLocalizations.of(context)!;

    // Show confirmation dialogue
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localization.confirmChanges),
          content: Text(localization.confirmChangesMessage),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(localization.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final name = _nameController.text;
                  final prefix = _prefixController.text;

                  try {
                    // Update component type
                    await ref
                        .read(componentTypeProvider.notifier)
                        .updateComponentType(
                          componentType.id,
                          componentType.copyWith(
                            name: name,
                            lastModified: DateTime.now(),
                          ),
                        );

                    // Updating or adding a prefix
                    if (prefixState != null) {
                      await ref
                          .read(componentPrefixProvider.notifier)
                          .updateComponentPrefix(
                            prefixState.id,
                            prefixState.copyWith(prefix: prefix),
                          );
                    }

                    setState(() {}); // Add setState call after update

                    // Wyświetl powiadomienie o sukcesie
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localization.changesSavedSuccess),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    // Error handling
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${localization.errorSavingChanges}: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                Navigator.pop(dialogContext); //Close dialogue
              },
              child: Text(localization.confirm),
            ),
          ],
        );
      },
    );
  }

  void _toggleSubcomponentState(
      BuildContext context, SubcomponentResponseDto subcomponent) {
    final localization = AppLocalizations.of(context)!;
    final isActive = subcomponent.deletedAt == null;
    final action = isActive ? localization.deactivate : localization.activate;
    final confirmMessage = isActive
        ? localization.deactivateSubcomponentConfirm
        : localization.activateSubcomponentConfirm;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(action),
          content: Text(confirmMessage),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localization.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                //We create an UpdateSubcomponentDto object with the current data and the changed `deletedAt`.
                final updateDto = UpdateSubcomponentDto(
                  name: subcomponent.name,
                  componentTypeId: subcomponent.componentTypeId,
                  sortOrder: subcomponent.sortOrder,
                  isActivity: subcomponent.isActivity,
                  deletedAt: isActive ? DateTime.now() : null,
                );

                await ref
                    .read(subcomponentProvider.notifier)
                    .updateSubcomponent(subcomponent.id, updateDto);
                setState(() {});
              },
              child: Text(localization.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final componentTypesAsync = ref.watch(componentTypeProvider);
    final prefixesAsync = ref.watch(componentPrefixProvider);
    final subcomponentsAsync = ref.watch(subcomponentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.editComponentType),
      ),
      body: componentTypesAsync.when(
        data: (componentTypes) {
          final componentType = componentTypes.firstWhere(
            (type) => type.id == widget.componentTypeId,
            orElse: () => throw Exception('Component type not found'),
          );

          return prefixesAsync.when(
            data: (prefixes) {
              final prefix = prefixes.firstWhereOrNull(
                (p) => p.componentTypeId == componentType.id,
              );

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: localization.componentTypeName,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? localization.validationRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _prefixController,
                        decoration: InputDecoration(
                          labelText: localization.prefix,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        localization.subcomponents,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      subcomponentsAsync.when(
                        data: (subcomponents) {
                          final filteredSubcomponents = subcomponents
                              .where((sub) =>
                                  sub.componentTypeId == componentType.id)
                              .toList()
                            ..sort(
                                (a, b) => a.sortOrder.compareTo(b.sortOrder));

                          return ReorderableColumn(
                            children: List.generate(
                              filteredSubcomponents.length,
                              (index) {
                                final subcomponent =
                                    filteredSubcomponents[index];
                                return ListTile(
                                  key: ValueKey(subcomponent.id),
                                  leading: Icon(
                                    Icons.circle,
                                    color: subcomponent.deletedAt == null
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text(
                                    subcomponent.name,
                                    style: TextStyle(
                                      decoration: subcomponent.deletedAt == null
                                          ? TextDecoration.none
                                          : TextDecoration.lineThrough,
                                    ),
                                  ),
                                  subtitle: Text(
                                      '${localization.sortOrder}: ${subcomponent.sortOrder}'),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      _toggleSubcomponentState(
                                          context, subcomponent);
                                    },
                                    child: Text(
                                      subcomponent.deletedAt == null
                                          ? localization.deactivate
                                          : localization.activate,
                                    ),
                                  ),
                                );
                              },
                            ),
                            onReorder: (oldIndex, newIndex) async {
                              await _reorderSubcomponents(
                                  filteredSubcomponents, oldIndex, newIndex);
                              setState(() {});
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(
                          child: Text(localization.errorLoadingSubcomponents),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _updateComponentType(
                              componentType,
                              prefix,
                            ),
                            child: Text(localization.saveChanges),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(localization.errorLoadingPrefixes),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(localization.errorLoadingComponentTypes),
        ),
      ),
    );
  }
}
