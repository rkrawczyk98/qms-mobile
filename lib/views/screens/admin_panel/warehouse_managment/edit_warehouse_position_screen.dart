import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/update_warehouse_position_dto.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/warehouse_position_response_dto.dart';
import 'package:qms_mobile/data/providers/warehouse_module/warehouse_provider.dart';
import 'package:qms_mobile/data/providers/warehouse_module/warehouse_position_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_dropdown_button.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';

class EditWarehousePositionScreen extends ConsumerStatefulWidget {
  final WarehousePositionResponseDto position;

  const EditWarehousePositionScreen({super.key, required this.position});

  @override
  ConsumerState<EditWarehousePositionScreen> createState() =>
      _EditWarehousePositionScreenState();
}

class _EditWarehousePositionScreenState
    extends ConsumerState<EditWarehousePositionScreen> {
  late final TextEditingController _nameController;
  int? _selectedWarehouseId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.position.name);
    _selectedWarehouseId = widget.position.warehouseId;
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
        title: Text(localizations.editWarehousePosition),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
          child: CenteredContainerWidget(
            screenWidth: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                CustomTextField(
                  label: localizations.name,
                  hint: localizations.enterWarehousePositionName,
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
                CustomDropdownButton(
                  text: localizations.selectWarehouse,
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
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: localizations.save,
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    if (name.isNotEmpty && _selectedWarehouseId != null) {
                      final dto = UpdateWarehousePositionDto(
                        name: name,
                        warehouseId: _selectedWarehouseId,
                      );

                      await ref
                          .read(warehousePositionServiceProvider)
                          .updateWarehousePosition(widget.position.id, dto);

                      ref
                          .read(warehousePositionProvider.notifier)
                          .updateWarehousePosition(
                              widget.position.id,
                              WarehousePositionResponseDto(
                                id: widget.position.id,
                                name: name,
                                warehouseId: _selectedWarehouseId!,
                                creationDate: widget.position.creationDate,
                                lastModified: DateTime.now(),
                              ));

                      if (mounted) {
                        CustomSnackbar.showSuccessSnackbar(
                          context,
                          localizations.warehousePositionUpdatedSuccess,
                        );
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
