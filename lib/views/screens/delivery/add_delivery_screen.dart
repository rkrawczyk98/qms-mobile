import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/create_delivery_dto.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_provider.dart';
import 'package:qms_mobile/data/providers/component_module/component_type_provider.dart';
import 'package:qms_mobile/data/providers/customer_module/customer_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';

class AddDeliveryScreen extends ConsumerStatefulWidget {
  const AddDeliveryScreen({super.key});

  @override
  AddDeliveryScreenState createState() => AddDeliveryScreenState();
}

class AddDeliveryScreenState extends ConsumerState<AddDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedComponentType;
  int? _selectedCustomer;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    final localization = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      final newDelivery = CreateDeliveryDto(
        componentTypeId: _selectedComponentType!,
        customerId: _selectedCustomer!,
        deliveryDate: _selectedDate ?? DateTime.now(),
      );

      try {
        final newDeliveryId = await ref
            .read(deliveryProvider.notifier)
            .addDelivery(newDelivery);

        if (mounted) {
          CustomSnackbar.showSuccessSnackbar(
            context,
            localization.deliveryAddedSuccess,
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/delivery-details',
                  arguments: newDeliveryId,
                ),
                child: Text(localization.details,
                    style: const TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/delivery-contents',
                  arguments: newDeliveryId,
                ),
                child: Text(localization.contents,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        }
      } catch (e) {
        if (mounted) {
          CustomSnackbar.showErrorSnackbar(
            context,
            localization.deliveryAddError,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final componentTypes = ref.watch(componentTypeProvider);

                  return componentTypes.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) =>
                        Text(localization.fetchErrorComponentTypes),
                    data: (types) {
                      if (types.isEmpty) {
                        return Text(localization.noComponentTypesAvailable);
                      }

                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                            labelText: localization.componentType),
                        value: _selectedComponentType,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedComponentType = newValue;
                          });
                        },
                        items: types.map((type) {
                          return DropdownMenuItem<int>(
                            value: type.id,
                            child: Text(type.name),
                          );
                        }).toList(),
                        validator: (value) => value == null
                            ? localization.selectComponentTypeError
                            : null,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) {
                  final customers = ref.watch(customerProvider);

                  return customers.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) =>
                        Text(localization.fetchErrorCustomers),
                    data: (customers) {
                      if (customers.isEmpty) {
                        return Text(localization.noCustomersAvailable);
                      }

                      return DropdownButtonFormField<int>(
                        decoration:
                            InputDecoration(labelText: localization.customer),
                        value: _selectedCustomer,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedCustomer = newValue;
                          });
                        },
                        items: customers.map((customer) {
                          return DropdownMenuItem<int>(
                            value: customer.id,
                            child: Text(customer.name),
                          );
                        }).toList(),
                        validator: (value) => value == null
                            ? localization.selectCustomerError
                            : null,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : _selectedDate!.toLocal().toString().split(' ')[0],
                ),
                decoration: InputDecoration(labelText: localization.deliveryDate),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectDate(context);
                },
                validator: (value) {
                  if (_selectedDate == null) {
                    return localization.selectDeliveryDateError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(localization.addDelivery),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
