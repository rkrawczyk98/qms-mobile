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
import 'package:qms_mobile/views/widgets/custom_switch_list_tile.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    _prefixController.dispose();
    super.dispose();
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
                  expanded), // Allows quick moving of items only when all are collapsed
              children: List.generate(_subcomponents.length, (index) {
                return ReorderableDragStartListener(
                  key: ValueKey(index),
                  index: index,
                  child: SubcomponentCard(
                    index: index,
                    subcomponent: _subcomponents[index],
                    statuses: statuses,
                    expanded: _expandedState[index] ?? false,
                    onToggleExpanded: () async {
                      setState(() {
                        _expandedState[index] = !_expandedState[index]!;
                      });
                    },
                    onRemove: () async {
                      _removeSubcomponent(index);
                    },
                    onUpdate: (updated) {
                      setState(() {
                        _subcomponents[index] = updated;
                      });
                    },
                    onNameChanged: (newName) {
                      setState(() {
                        _subcomponents[index] =
                            _subcomponents[index].copyWith(name: newName);
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
              onPressed: _addSubcomponent,
              icon: const Icon(
                Icons.add,
              ),
              label: Text(localization.addSubcomponent,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
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
  final Function(String) onNameChanged;
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
    required this.onNameChanged,
    this.dragHandle,
  });

  @override
  _SubcomponentCardState createState() => _SubcomponentCardState();
}

class _SubcomponentCardState extends State<SubcomponentCard> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              onPressed: () async {
                // _isModified = false;
                _nameController.text = widget.subcomponent.name;
                widget.onToggleExpanded();
              },
            ),
          ),
          if (widget.expanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).colorScheme.surface,
                            labelText: localization.subcomponentName,
                            hintText: localization.subcomponentName,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.info_outline,
                                      color: Colors.blue),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text(localization.nameSubmitInfo),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.save,
                                      color: Colors.green),
                                  onPressed: () {
                                    widget.onNameChanged(_nameController.text);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStatusChips<PrimaryStatusDto>(
                    title: localization.primaryStatuses,
                    statuses: widget.subcomponent.primaryStatuses,
                    allStatuses: widget.statuses,
                    createStatus: (id) =>
                        PrimaryStatusDto(statusId: id, sortOrder: 0),
                    copyWith: (updatedStatuses) => widget.subcomponent.copyWith(
                      primaryStatuses: updatedStatuses,
                    ),
                    onUpdate: widget.onUpdate,
                  ),
                  const SizedBox(height: 16),
                  _buildStatusChips<SecondaryStatusDto>(
                    title: localization.secondaryStatuses,
                    statuses: widget.subcomponent.secondaryStatuses,
                    allStatuses: widget.statuses,
                    createStatus: (id) =>
                        SecondaryStatusDto(statusId: id, sortOrder: 0),
                    copyWith: (updatedStatuses) => widget.subcomponent.copyWith(
                      secondaryStatuses: updatedStatuses,
                    ),
                    onUpdate: widget.onUpdate,
                  ),
                  const SizedBox(height: 16),
                  CustomSwitchListTile(
                    title: localization.isActivity,
                    value: widget.subcomponent.isActivity,
                    onChanged: (value) {
                      widget.onUpdate(
                          widget.subcomponent.copyWith(isActivity: value));
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        widget.onRemove();
                      },
                      icon: const Icon(Icons.delete),
                      label: Text(localization.removeSubcomponent),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChips<T>({
    required String title,
    required List<T> statuses,
    required List<dynamic> allStatuses,
    required T Function(int id) createStatus,
    required SubcomponentDetailsDto Function(List<T>) copyWith,
    required Function(SubcomponentDetailsDto) onUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.0,
          runSpacing: 4.0,
          children: allStatuses.map((status) {
            final isSelected =
                statuses.any((s) => (s as dynamic).statusId == status.id);
            return ChoiceChip(
              showCheckmark: false,
              label: Text(status.name),
              selected: isSelected,
              onSelected: (selected) {
                onUpdate(copyWith(
                  _updateStatuses<T>(
                    statuses,
                    createStatus,
                    status.id,
                    selected,
                  ),
                ));
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  List<T> _updateStatuses<T>(
    List<T> statuses,
    T Function(int id) createStatus,
    int statusId,
    bool selected,
  ) {
    final updatedStatuses = List<T>.from(statuses);
    if (selected) {
      updatedStatuses.add(createStatus(statusId));
    } else {
      updatedStatuses.removeWhere((s) => (s as dynamic).statusId == statusId);
    }
    return updatedStatuses;
  }
}
