import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/user_module/user_provider.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/utils/exceptions/conflict_exception.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_checkbox.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateUserScreen extends ConsumerStatefulWidget {
  const CreateUserScreen({super.key});

  @override
  CreateUserScreenState createState() => CreateUserScreenState();
}

class CreateUserScreenState extends ConsumerState<CreateUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _showRoles = false;
  bool _showPermissions = false;
  bool _isRoleChecked = false;
  bool _isPermissionChecked = false;

  Future<void> _createUser() async {
    final userService = ref.read(userServiceProvider);
    final context = navigationService.navigatorKey.currentContext;
    final localizations = AppLocalizations.of(context!)!;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await userService.createUser(
        _usernameController.text,
        _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.userCreatedSuccessfully)),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = localizations.unexpectedError;
        });
      }
    } on ConflictException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = localizations.unexpectedError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.createUserTitle),
      ),
      body: CenteredContainerWidget(
        screenWidth: screenWidth,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: localizations.username,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: localizations.password,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CustomCheckbox(
                isChecked: _isRoleChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isRoleChecked = value ?? false;
                    _showRoles = _isRoleChecked;
                  });
                },
                text: localizations.addRole,
              ),
              if (_showRoles) ...[
                const SizedBox(height: 8),
                // add role selection list
              ],
              const SizedBox(height: 16),
              CustomCheckbox(
                isChecked: _isPermissionChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isPermissionChecked = value ?? false;
                    _showPermissions = _isPermissionChecked;
                  });
                },
                text: localizations.addPermission,
              ),
              if (_showPermissions) ...[
                const SizedBox(height: 8),
                //add permissions selection list
              ],
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: localizations.createUserButton,
                      onPressed: _createUser,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
