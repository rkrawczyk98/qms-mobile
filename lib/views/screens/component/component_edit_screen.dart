import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/update_component_dto.dart';
import 'package:qms_mobile/data/providers/component_module/component_provider.dart';
import 'package:qms_mobile/data/providers/component_module/component_status_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';

class ComponentEditScreen extends ConsumerStatefulWidget {
  final int componentId;

  const ComponentEditScreen({super.key, required this.componentId});

  @override
  ConsumerState<ComponentEditScreen> createState() =>
      _ComponentManageScreenState();
}

class _ComponentManageScreenState extends ConsumerState<ComponentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameOneController = TextEditingController();
  final TextEditingController _nameTwoController = TextEditingController();
  final TextEditingController _outsideNumberController =
      TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _wzNumberController = TextEditingController();

  DateTime? _controlDate;
  DateTime? _productionDate;
  DateTime? _shippingDate;
  DateTime? _scrappedAt;
  int? _statusId;

  @override
  void initState() {
    super.initState();
    final component = ref
        .read(componentProvider)
        .value
        ?.firstWhere((c) => c.id == widget.componentId);

    if (component != null) {
      _nameOneController.text = component.nameOne;
      _nameTwoController.text = component.nameTwo ?? '';
      _outsideNumberController.text = component.outsideNumber ?? '';
      _sizeController.text = component.size?.toString() ?? '';
      _wzNumberController.text = component.wzNumber ?? '';
      _controlDate = component.controlDate;
      _productionDate = component.productionDate;
      _shippingDate = component.shippingDate;
      _scrappedAt = component.scrappedAt;
      _statusId = component.status.id;
    }
  }

  Future<void> _selectDate(
    BuildContext context, {
    required DateTime? initialDate,
    required void Function(DateTime?) onDateSelected,
  }) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        onDateSelected(pickedDate);
      });
    }
  }

  Future<void> _updateComponent() async {
    if (_formKey.currentState!.validate()) {
      final updatedDto = UpdateComponentDto(
        nameOne: _nameOneController.text,
        nameTwo: _nameTwoController.text,
        outsideNumber: _outsideNumberController.text,
        size: double.tryParse(_sizeController.text),
        wzNumber: _wzNumberController.text,
        controlDate: _controlDate,
        productionDate: _productionDate,
        shippingDate: _shippingDate,
        scrappedAt: _scrappedAt,
      );

      await ref
          .read(componentProvider.notifier)
          .updateComponent(widget.componentId, updatedDto);

      if (mounted) {
        CustomSnackbar.showSuccessSnackbar(
            context, AppLocalizations.of(context)!.componentUpdated);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuses = ref.watch(componentStatusProvider);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.editComponent),
      ),
      body: statuses.when(
        data: (statusList) => Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameOneController,
                  decoration:
                      InputDecoration(labelText: localization.componentNameOne),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.requiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameTwoController,
                  decoration:
                      InputDecoration(labelText: localization.componentNameTwo),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _outsideNumberController,
                  decoration:
                      InputDecoration(labelText: localization.outsideNumber),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _sizeController,
                  decoration: InputDecoration(labelText: localization.size),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _wzNumberController,
                  decoration: InputDecoration(labelText: localization.wzNumber),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                _buildDateField(
                  label: localization.controlDate,
                  selectedDate: _controlDate,
                  onDateSelected: (date) => _controlDate = date,
                ),
                const SizedBox(height: 20),
                _buildDateField(
                  label: localization.productionDate,
                  selectedDate: _productionDate,
                  onDateSelected: (date) => _productionDate = date,
                ),
                const SizedBox(height: 20),
                _buildDateField(
                  label: localization.shippingDate,
                  selectedDate: _shippingDate,
                  onDateSelected: (date) => _shippingDate = date,
                ),
                const SizedBox(height: 20),
                _buildDateField(
                  label: localization.scrappedDate,
                  selectedDate: _scrappedAt,
                  onDateSelected: (date) => _scrappedAt = date,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: _statusId,
                  decoration: InputDecoration(labelText: localization.status),
                  onChanged: (newValue) {
                    setState(() {
                      _statusId = newValue;
                    });
                  },
                  items: statusList.map((status) {
                    return DropdownMenuItem<int>(
                      value: status.id,
                      child: Text(status.name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: _updateComponent,
                    child: Text(
                      localization.saveChanges,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(localization.statusLoadingError)),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required void Function(DateTime?) onDateSelected,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: TextEditingController(
              text: selectedDate?.toLocal().toString().split(' ')[0] ?? '',
            ),
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() => onDateSelected(null));
                },
                tooltip: AppLocalizations.of(context)!.clearDate,
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(
              context,
              initialDate: selectedDate,
              onDateSelected: onDateSelected,
            ),
          ),
        ),
      ],
    );
  }
}
