import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery_status/create_delivery_status_dto.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_status_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';

class CreateDeliveryStatusScreen extends ConsumerStatefulWidget {
  const CreateDeliveryStatusScreen({super.key});

  @override
  ConsumerState<CreateDeliveryStatusScreen> createState() =>
      _CreateDeliveryStatusScreenState();
}

class _CreateDeliveryStatusScreenState
    extends ConsumerState<CreateDeliveryStatusScreen> {
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

  Future<void> _saveDeliveryStatus(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      CustomSnackbar.showErrorSnackbar(
          context, localizations.enterDeliveryStatusNameError);
      return;
    }

    final dto = CreateDeliveryStatusDto(name: name);

    try {
      await ref.read(deliveryStatusProvider.notifier).addDeliveryStatus(dto);
      if (mounted) {
        CustomSnackbar.showSuccessSnackbar(
          context,
          localizations.deliveryStatusCreatedSuccess,
        );
        Navigator.pop(context); // Navigate back after successful creation
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showErrorSnackbar(
          context,
          localizations.deliveryStatusCreationError,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.createDeliveryStatus),
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
                      const Icon(
                        Icons.check_circle_outline,
                        size: 150,
                      ),
                      Text(
                        localizations.addDeliveryStatus,
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomTextField(
                        label: localizations.deliveryStatusName,
                        hint: localizations.enterDeliveryStatusName,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 25),
                      CustomButton(
                        text: localizations.save,
                        onPressed: () => _saveDeliveryStatus(context),
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
