import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/create_warehouse_position_dto.dart';
import 'package:qms_mobile/data/providers/warehouse_module/warehouse_provider.dart';
import 'package:qms_mobile/data/providers/warehouse_module/warehouse_position_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_dropdown_button.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';

class CreateWarehousePositionScreen extends ConsumerStatefulWidget {
  const CreateWarehousePositionScreen({super.key});

  @override
  ConsumerState<CreateWarehousePositionScreen> createState() =>
      _CreateWarehousePositionScreenState();
}

class _CreateWarehousePositionScreenState
    extends ConsumerState<CreateWarehousePositionScreen> {
  late final TextEditingController _nameController;
  int? _selectedWarehouseId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final localizations = AppLocalizations.of(context)!;
    final warehouses = ref.watch(warehouseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.createWarehousePosition),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
          child: CenteredContainerWidget(
            screenWidth: MediaQuery.of(context).size.width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double containerWidth =
                    constraints.maxWidth < 600 ? constraints.maxWidth : 500;

                return SizedBox(
                  width: containerWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 150,
                      ),
                      Text(
                        localizations.addWarehousePosition,
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomTextField(
                        label: localizations.name,
                        hint: localizations.enterWarehousePositionName,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 25),
                      warehouses.isEmpty
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: CustomDropdownButton<int>(
                                text: localizations.selectWarehouse,
                                tooltipMessage:
                                    localizations.selectWarehouseTooltip,
                                items: warehouses
                                    .map((warehouse) => DropdownMenuItem<int>(
                                          value: warehouse.id,
                                          child: Text(warehouse.name),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedWarehouseId = value;
                                  });
                                },
                              )),
                      const SizedBox(height: 25),
                      CustomButton(
                        text: localizations.save,
                        onPressed: () async {
                          final name = _nameController.text.trim();
                          if (name.isNotEmpty && _selectedWarehouseId != null) {
                            final dto = CreateWarehousePositionDto(
                              name: name,
                              warehouseId: _selectedWarehouseId!,
                            );

                            final newPosition = await ref
                                .read(warehousePositionServiceProvider)
                                .createWarehousePosition(dto);

                            if (mounted) {
                              ref
                                  .read(warehousePositionProvider.notifier)
                                  .addWarehousePosition(newPosition);
                              CustomSnackbar.showSuccessSnackbar(
                                context,
                                localizations.warehousePositionCreatedSuccess,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
