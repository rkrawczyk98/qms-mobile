import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/create_component_dto.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/delivery_response_dto.dart';
import 'package:qms_mobile/data/providers/component_module/component_provider.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddComponentScreen extends ConsumerStatefulWidget {
  const AddComponentScreen({super.key});

  @override
  ConsumerState<AddComponentScreen> createState() => _AddComponentScreenState();
}

class _AddComponentScreenState extends ConsumerState<AddComponentScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _componentName;
  DateTime? _controlDate;
  DateTime? _productionDate;
  double? _componentSize;
  DeliveryResponseDto? _selectedDelivery;

  Future<void> _selectDate(BuildContext context, bool isControlDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isControlDate) {
          _controlDate = picked;
        } else {
          _productionDate = picked;
        }
      });
    }
  }

  Future<void> _selectDelivery(BuildContext context) async {
    final selectedDelivery = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliverySelectionScreen(),
      ),
    ) as DeliveryResponseDto?;
    if (selectedDelivery != null) {
      setState(() {
        _selectedDelivery = selectedDelivery;
      });
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final newComponent = CreateComponentDto(
        nameOne: _componentName!,
        controlDate: _controlDate,
        productionDate: _productionDate,
        size: _componentSize!,
        deliveryId: _selectedDelivery!.id,
      );

      try {
        final createdComponent = await ref
            .read(componentProvider.notifier).addComponent(newComponent);

        if (!mounted) return;
        CustomSnackbar.showSuccessSnackbar(
          context,
          AppLocalizations.of(context)!.componentAddedSuccessfully,
          actions: [
            TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/component-details',
                arguments: createdComponent.id,
              ),
              child: Text(AppLocalizations.of(context)!.details),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/component-manage',
                arguments: createdComponent.id,
              ),
              child: Text(AppLocalizations.of(context)!.manage),
            ),
          ],
        );
      } catch (e) {
        if (!mounted) return;
        CustomSnackbar.showErrorSnackbar(
          context,
          AppLocalizations.of(context)!.componentAddError,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: localization.componentNumber,
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                        onChanged: (value) => _componentName = value,
                        validator: (value) => value == null || value.isEmpty
                            ? localization.validationRequired
                            : null,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _selectDelivery(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: localization.deliveryNumber,
                                hintText: _selectedDelivery?.number ?? '',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                            validator: (_) => _selectedDelivery == null
                                ? localization.validationRequired
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: localization.componentSize,
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (value) =>
                            _componentSize = double.tryParse(value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localization.validationRequired;
                          }
                          final parsed = double.tryParse(value);
                          if (parsed == null) {
                            return localization.validationInvalidNumber;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDatePickerField(
                        context,
                        labelText: localization.controlDate,
                        selectedDate: _controlDate,
                        onTap: () => _selectDate(context, true),
                      ),
                      const SizedBox(height: 16),
                      _buildDatePickerField(
                        context,
                        labelText: localization.productionDate,
                        selectedDate: _productionDate,
                        onTap: () => _selectDate(context, false),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _submitForm(context),
                        child: Text(localization.addComponent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(
    BuildContext context, {
    required String labelText,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: TextEditingController(
        text: selectedDate != null
            ? selectedDate.toLocal().toString().split(' ')[0]
            : '',
      ),
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        onTap();
      },
      validator: (value) => selectedDate == null
          ? AppLocalizations.of(context)!.validationRequired
          : null,
    );
  }
}

class DeliverySelectionScreen extends ConsumerStatefulWidget {
  const DeliverySelectionScreen({Key? key}) : super(key: key);

  @override
  _DeliverySelectionScreenState createState() =>
      _DeliverySelectionScreenState();
}

class _DeliverySelectionScreenState
    extends ConsumerState<DeliverySelectionScreen> {
  String _searchQuery = '';
  String? _selectedComponentType;

  @override
  void initState() {
    super.initState();
    // Automatic data download
    Future.microtask(
        () => ref.read(deliveryProvider.notifier).fetchDeliveries());
  }

  @override
  Widget build(BuildContext context) {
    final deliveriesAsync = ref.watch(deliveryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectDelivery),
      ),
      body: deliveriesAsync.when(
        data: (deliveries) {
          // Filtering by component type and number
          final filteredDeliveries = deliveries.where((delivery) {
            final matchesQuery = _searchQuery.isEmpty ||
                delivery.number
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
            final matchesType = _selectedComponentType == null ||
                delivery.componentType?.name == _selectedComponentType;
            return matchesQuery && matchesType;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.filterDeliveries,
                    suffixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedComponentType,
                  hint: Text(AppLocalizations.of(context)!.filterByType),
                  items: [
                    for (final type in {
                      ...deliveries
                          .map((delivery) => delivery.componentType?.name)
                          .where((name) => name != null)
                    })
                      DropdownMenuItem(
                        value: type!,
                        child: Text(type),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedComponentType = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: filteredDeliveries.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredDeliveries.length,
                        itemBuilder: (context, index) {
                          final delivery = filteredDeliveries[index];
                          return ListTile(
                            title: Text(delivery.number),
                            subtitle: Text(delivery.componentType?.name ?? ''),
                            onTap: () => Navigator.pop(context, delivery),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                            AppLocalizations.of(context)!.noDeliveriesFound),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}
