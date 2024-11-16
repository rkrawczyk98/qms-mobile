import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/models/DTOs/customer_module/create_customer_dto.dart';
import 'package:qms_mobile/data/providers/customer_module/customer_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';

class CreateCustomerScreen extends ConsumerStatefulWidget {
  const CreateCustomerScreen({super.key});

  @override
  ConsumerState<CreateCustomerScreen> createState() =>
      _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends ConsumerState<CreateCustomerScreen> {
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
        title: Text(localizations.createCustomer),
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
                        Icons.person_add_alt_1,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 150,
                      ),
                      Text(
                        localizations.addCustomer,
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
                            final dto = CreateCustomerDto(name: name);

                            final newCustomer = await ref
                                .read(customerServiceProvider)
                                .createCustomer(dto);

                            if (mounted) {
                              ref
                                  .read(customerProvider.notifier)
                                  .addCustomer(newCustomer);
                              CustomSnackbar.showSuccessSnackbar(context,
                                  localizations.customerCreatedSuccess);
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
