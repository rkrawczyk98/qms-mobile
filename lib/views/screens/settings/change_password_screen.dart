import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/auth_provider.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  

  Future<void> _changePassword() async {
  if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = ref.read(authServiceProvider);
    final message = await authService.changePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (message == AppLocalizations.of(context)!.passwordChangedSuccessfully ) {
      CustomSnackbar.showSuccessSnackbar(
        context,
        message ?? '',
      );
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = message;
      });
    }
  }

  VoidCallback? getOnPressedCallback() {
    if (_isLoading) return null;
    return () => _changePassword();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.changePasswordTitle)),
      body: Center(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
        child: CenteredContainerWidget(
          screenWidth: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              CustomTextField(
                label: localizations.currentPassword,
                hint: localizations.enterCurrentPassword,
                controller: _currentPasswordController,
                isObscure: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: localizations.newPassword,
                hint: localizations.enterNewPassword,
                controller: _newPasswordController,
                isObscure: true,
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
              ],
              CustomButton(
                text: _isLoading
                    ? localizations.loading
                    : localizations.changePassword,
                onPressed: _isLoading ? null : () => _changePassword(),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
