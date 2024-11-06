import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/user/user_role_response_dto.dart';
import 'package:qms_mobile/data/providers/user_provider.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';
import 'package:qms_mobile/views/dialogs/error_details_dialog.dart';

class ManageUserScreen extends ConsumerStatefulWidget {
  const ManageUserScreen({super.key});

  @override
  ManageUserScreenState createState() => ManageUserScreenState();
}

class ManageUserScreenState extends ConsumerState<ManageUserScreen> {
  List<UserRoleResponseDto>? _users;
  UserRoleResponseDto? _selectedUser;
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final userService = ref.read(userServiceProvider);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final users = await userService.getUsersWithRoles();

    setState(() {
      _isLoading = false;
      _users = users;
    });
  }

Future<void> _resetPassword() async {
  if (_selectedUser == null) return;
  final userService = ref.read(userServiceProvider);
  final context = navigationService.navigatorKey.currentContext;
  final localizations = AppLocalizations.of(context!)!;

  setState(() => _isLoading = true);

  final success = await userService.resetPassword(
    _selectedUser!.user.id,
    _newPasswordController.text,
  );

  setState(() => _isLoading = false);

  if (success) {
    CustomSnackbar.showSuccessSnackbar(
      context,
      localizations.passwordResetSuccess,
    );
    _newPasswordController.clear();
  }
}

  Future<void> _deleteUser() async {
    if (_selectedUser == null) return;
    final userService = ref.read(userServiceProvider);
    final context = navigationService.navigatorKey.currentContext;
    final localizations = AppLocalizations.of(context!)!;

    setState(() => _isLoading = true);

    final success = await userService.deleteUser(_selectedUser!.user.id);

    setState(() => _isLoading = false);

    if (success) {
      CustomSnackbar.showSuccessSnackbar(
        context,
        localizations.userDeletedSuccess,
      );
      _fetchUsers();
      setState(() => _selectedUser = null);
    } else {
      CustomSnackbar.showErrorSnackbar(
        context,
        localizations.deleteUserError,
        onActionTap: () => showDialog(
          context: context,
          builder: (_) => ErrorDetailsDialog(
            errorMessage: localizations.deleteUserError,
            errorCode: "500",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.userManagementTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CenteredContainerWidget(
          screenWidth: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.selectUser,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const CircularProgressIndicator()
                  : DropdownButton<UserRoleResponseDto>(
                      isExpanded: true,
                      hint: Text(localizations.selectUserHint),
                      value: _selectedUser,
                      onChanged: (UserRoleResponseDto? newUser) {
                        setState(() {
                          _selectedUser = newUser;
                        });
                      },
                      items: _users?.map((user) {
                        return DropdownMenuItem<UserRoleResponseDto>(
                          value: user,
                          child: Text(user.user.username),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 20),
              if (_selectedUser != null) ...[
                Text(
                  localizations.userRoles,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 5),
                Column(
                  children: _selectedUser!.roles
                      .map((role) => Text(role.name))
                      .toList(),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _newPasswordController,
                  label: localizations.newPassword,
                  hint: localizations.enterNewPassword,
                  isObscure: true,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: localizations.resetPasswordButton,
                  onPressed: _isLoading ? null : _resetPassword,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: localizations.deleteUserButton,
                  onPressed: _isLoading ? null : _deleteUser,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
