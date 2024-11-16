import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/create_warehouse_dto.dart';
import 'package:qms_mobile/data/providers/warehouse_module/warehouse_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';

class CreateWarehouseScreen extends ConsumerStatefulWidget {
  const CreateWarehouseScreen({super.key});

  @override
  ConsumerState<CreateWarehouseScreen> createState() =>
      _CreateWarehouseScreenState();
}

class _CreateWarehouseScreenState extends ConsumerState<CreateWarehouseScreen> {
  late final TextEditingController _nameController;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.createWarehouse),
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
                        Icons.warehouse,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 150,
                      ),
                      Text(
                        localizations.addWarehouse,
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomTextField(
                        label: localizations.name,
                        hint: localizations.enterWarehouseName,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 25),
                      CustomButton(
                        text: localizations.save,
                        onPressed: () async {
                          final name = _nameController.text.trim();
                          if (name.isNotEmpty) {
                            final dto = CreateWarehouseDto(name: name);

                            final newWarehouse = await ref
                                .read(warehouseServiceProvider)
                                .createWarehouse(dto);

                            if (mounted) {
                              ref
                                  .read(warehouseProvider.notifier)
                                  .addWarehouse(newWarehouse);
                              CustomSnackbar.showSuccessSnackbar(
                                context,
                                localizations.warehouseCreatedSuccess,
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
