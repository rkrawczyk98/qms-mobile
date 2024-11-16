import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/customer_module/customer_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/customer_module/update_customer_dto.dart';
import 'package:qms_mobile/data/providers/customer_module/customer_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';

class EditCustomerScreen extends ConsumerStatefulWidget {
  final int customerId;
  final String initialName;

  const EditCustomerScreen({
    super.key,
    required this.customerId,
    required this.initialName,
  });

  @override
  ConsumerState<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends ConsumerState<EditCustomerScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
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
        title: Text(localizations.editCustomer),
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
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 150,
                      ),
                      Text(
                        localizations.editCustomerDetails,
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomTextField(
                        label: localizations.name,
                        hint: localizations.enterCustomerName,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 25),
                      CustomButton(
                        text: localizations.save,
                        onPressed: () async {
                          final name = _nameController.text.trim();
                          if (name.isNotEmpty) {
                            final dto = UpdateCustomerDto(name: name);

                            await ref
                                .read(customerServiceProvider)
                                .updateCustomer(widget.customerId, dto);

                            if (mounted) {
                              final updatedCustomer = CustomerResponseDto(
                                id: widget.customerId,
                                name: name,
                                creationDate:
                                    DateTime.now(), // Adjust as needed
                                lastModified: DateTime.now(),
                              );
                              ref
                                  .read(customerProvider.notifier)
                                  .updateCustomer(
                                      widget.customerId, updatedCustomer);

                              CustomSnackbar.showSuccessSnackbar(
                                context,
                                localizations.customerUpdatedSuccess,
                              );
                              Navigator.pop(context);
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
