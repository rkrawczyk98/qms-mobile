import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/create_with_details_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/primary_status_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/secondary_status_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/subcomponent_details_dto.dart';
import 'package:qms_mobile/data/providers/component_module/component_type_provider.dart';
import 'package:qms_mobile/data/providers/component_module/subcomponent_status_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:reorderables/reorderables.dart';

class CreateComponentTypeScreen extends ConsumerStatefulWidget {
  const CreateComponentTypeScreen({super.key});

  @override
  ConsumerState<CreateComponentTypeScreen> createState() =>
      _CreateComponentTypeScreenState();
}

class _CreateComponentTypeScreenState
    extends ConsumerState<CreateComponentTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();

  final List<SubcomponentDetailsDto> _subcomponents = [];
  final Map<int, bool> _expandedState = {};

  @override
  void initState() {
    super.initState();
    ref.read(subcomponentStatusProvider.notifier).fetchAllStatuses();
  }

  void _addSubcomponent() {
    setState(() {
      final sortOrder = _subcomponents.length + 1;
      final newSubcomponent = SubcomponentDetailsDto(
        name: '',
        sortOrder: sortOrder,
        isActivity: false,
        primaryStatuses: [],
        secondaryStatuses: [],
      );
      _subcomponents.add(newSubcomponent);
      _expandedState[_subcomponents.length - 1] = true;
    });
  }

  void _removeSubcomponent(int index) {
    setState(() {
      _subcomponents.removeAt(index);
      _updateSortOrder();
    });
  }

  void _updateSortOrder() {
    for (int i = 0; i < _subcomponents.length; i++) {
      _subcomponents[i] = _subcomponents[i].copyWith(sortOrder: i + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuses = ref.watch(subcomponentStatusProvider);
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.createComponentTypeTitle,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: localization.componentTypeName,
                hintText: localization.componentTypeName,
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
                hintText: localization.prefix,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? localization.validationRequired
                  : null,
            ),
            const SizedBox(height: 24),
            Text(
              localization.subcomponents,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ReorderableColumn(
              needsLongPressDraggable: _expandedState.values.any((expanded) =>
                  expanded), //Allows quick moving of items only when all are collapsed
              children: List.generate(_subcomponents.length, (index) {
                return ReorderableDragStartListener(
                  key: ValueKey(index),
                  index: index,
                  child: SubcomponentCard(
                    index: index,
                    subcomponent: _subcomponents[index],
                    statuses: statuses,
                    expanded: _expandedState[index] ?? false,
                    onToggleExpanded: () {
                      setState(() {
                        _expandedState[index] = !_expandedState[index]!;
                      });
                    },
                    onRemove: () => _removeSubcomponent(index),
                    onUpdate: (updated) {
                      setState(() {
                        _subcomponents[index] = updated;
                      });
                    },
                    dragHandle: const Icon(Icons.drag_handle),
                  ),
                );
              }),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  final item = _subcomponents.removeAt(oldIndex);
                  _subcomponents.insert(newIndex, item);
                  _updateSortOrder();
                });
              },
            ),
            ElevatedButton.icon(
              style: const ButtonStyle(),
              onPressed: _addSubcomponent,
              icon: const Icon(
                Icons.add,
              ),
              label: Text(localization.addSubcomponent,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final dto = CreateWithDetailsDto(
                    name: _nameController.text,
                    prefix: _prefixController.text,
                    subcomponents: _subcomponents,
                  );
                  final success = await ref
                      .read(componentTypeWithDetailsProvider.notifier)
                      .createWithDetails(dto);

                  if (mounted && success) {
                    CustomSnackbar.showSuccessSnackbar(
                      context,
                      localization.successfullyCreatedComponentType,
                    );
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(localization.createComponentType,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}

class SubcomponentCard extends StatefulWidget {
  final int index;
  final SubcomponentDetailsDto subcomponent;
  final List statuses;
  final bool expanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onRemove;
  final Function(SubcomponentDetailsDto) onUpdate;
  final Widget? dragHandle;

  const SubcomponentCard({
    super.key,
    required this.index,
    required this.subcomponent,
    required this.statuses,
    required this.expanded,
    required this.onToggleExpanded,
    required this.onRemove,
    required this.onUpdate,
    this.dragHandle,
  });

  @override
  SubcomponentCardState createState() => SubcomponentCardState();
}

class SubcomponentCardState extends State<SubcomponentCard> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subcomponent.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: widget.dragHandle,
            title: Text(widget.subcomponent.name.isEmpty
                ? localization.subcomponentNamePlaceholder
                : widget.subcomponent.name),
            subtitle: Text(
                '${localization.sortOrder}: ${widget.subcomponent.sortOrder}'),
            trailing: IconButton(
              icon:
                  Icon(widget.expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: widget.onToggleExpanded,
            ),
          ),
          if (widget.expanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: localization.subcomponentName,
                      hintText: localization.subcomponentName,
                    ),
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty &&
                          value != widget.subcomponent.name) {
                        widget.onUpdate(
                            widget.subcomponent.copyWith(name: value));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(localization.primaryStatuses),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.subcomponent.primaryStatuses.map((status) {
                      final statusName = widget.statuses
                          .firstWhere((s) => s.id == status.statusId)
                          .name;
                      return Chip(
                        label: Text(statusName),
                        onDeleted: () {
                          final updatedStatuses =
                              List.of(widget.subcomponent.primaryStatuses)
                                ..remove(status);
                          widget.onUpdate(widget.subcomponent
                              .copyWith(primaryStatuses: updatedStatuses));
                        },
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<int>(
                    items: widget.statuses
                        .where((status) => !widget.subcomponent.primaryStatuses
                            .any((existing) =>
                                existing.statusId ==
                                status.id)) // Duplicate Avoidance Filter
                        .map<DropdownMenuItem<int>>((status) {
                      return DropdownMenuItem<int>(
                        value: status.id,
                        child: Text(status.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final updatedStatuses = [
                          ...widget.subcomponent.primaryStatuses,
                          PrimaryStatusDto(statusId: value, sortOrder: 0),
                        ];
                        widget.onUpdate(widget.subcomponent
                            .copyWith(primaryStatuses: updatedStatuses));
                      }
                    },
                    decoration: InputDecoration(
                      labelText: localization.addPrimaryStatus,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(localization.secondaryStatuses),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children:
                        widget.subcomponent.secondaryStatuses.map((status) {
                      final statusName = widget.statuses
                          .firstWhere((s) => s.id == status.statusId)
                          .name;
                      return Chip(
                        label: Text(statusName),
                        onDeleted: () {
                          final updatedStatuses =
                              List.of(widget.subcomponent.secondaryStatuses)
                                ..remove(status);
                          widget.onUpdate(widget.subcomponent
                              .copyWith(secondaryStatuses: updatedStatuses));
                        },
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<int>(
                    items: widget.statuses
                        .where((status) => !widget
                            .subcomponent.secondaryStatuses
                            .any((existing) =>
                                existing.statusId ==
                                status.id)) // Duplicate Avoidance Filter
                        .map<DropdownMenuItem<int>>((status) {
                      return DropdownMenuItem<int>(
                        value: status.id,
                        child: Text(status.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final updatedStatuses = [
                          ...widget.subcomponent.secondaryStatuses,
                          SecondaryStatusDto(statusId: value, sortOrder: 0),
                        ];
                        widget.onUpdate(widget.subcomponent
                            .copyWith(secondaryStatuses: updatedStatuses));
                      }
                    },
                    decoration: InputDecoration(
                      labelText: localization.addSecondaryStatus,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(localization.isActivity),
                    value: widget.subcomponent.isActivity,
                    onChanged: (value) {
                      widget.onUpdate(
                          widget.subcomponent.copyWith(isActivity: value));
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.delete),
                    label: Text(localization.removeSubcomponent),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
