import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user/create_user_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user/permission_id_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user/role_id_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user/create_user_with_roles_and_permissions_dto.dart';
import 'package:qms_mobile/data/providers/user_module/role_provider.dart';
import 'package:qms_mobile/data/providers/user_module/permission_provider.dart';
import 'package:qms_mobile/data/providers/user_module/user_provider.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/utils/exceptions/conflict_exception.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_checkbox.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';

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
  bool _useCustomPassword = false;
  bool _isPasswordVisible = false;
  final List<int> _selectedRoles = [];
  final List<int> _selectedPermissions = [];

  String _generateDefaultPassword(String username) {
    final year = DateTime.now().year;
    if (username.isEmpty) {
      return '';
    }
    return '${username[0].toUpperCase()}${username.substring(1)}$year!';
  }

  Future<void> _createUser() async {
    final userService = ref.read(userServiceProvider);
    final context = navigationService.navigatorKey.currentContext;
    final localizations = AppLocalizations.of(context!)!;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dto = CreateUserWithRolesAndPermissionsDto(
        user: CreateUserDto(
          username: _usernameController.text,
          password: _useCustomPassword
              ? _passwordController.text
              : _generateDefaultPassword(_usernameController.text),
        ),
        roles:
            _selectedRoles.map((roleId) => RoleIdDto(roleId: roleId)).toList(),
        permissions: _selectedPermissions
            .map((permId) => PermissionIdDto(permissionId: permId))
            .toList(),
      );

      final user = await userService.createUserWithRolesAndPermissions(dto);

      if (user != null) {
        CustomSnackbar.showSuccessSnackbar(
            context, localizations.userCreatedSuccessfully);
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = localizations.unexpectedError;
        });
      }
    } on ConflictException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = localizations.unexpectedError;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final roles = ref.watch(roleNotifierProvider);
    final permissions = ref.watch(permissionNotifierProvider);

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
              CustomTextField(
                controller: _usernameController,
                label: localizations.username,
                hint: localizations.enterNewUsername,
                onChanged: (text) {
                  if (!_useCustomPassword) {
                    _passwordController.text = _generateDefaultPassword(text);
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomCheckbox(
                isChecked: _useCustomPassword,
                onChanged: (bool? value) {
                  setState(() {
                    _useCustomPassword = value ?? false;
                    if (!_useCustomPassword) {
                      _passwordController.text =
                          _generateDefaultPassword(_usernameController.text);
                    }
                  });
                },
                text: localizations.useCustomPassword,
              ),
              if (_useCustomPassword)
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: localizations.password,
                    labelStyle:
                        TextStyle(color: theme.textTheme.bodySmall?.color),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
              const SizedBox(height: 16),
              CustomCheckbox(
                isChecked: _isRoleChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isRoleChecked = value ?? false;
                    _showRoles = _isRoleChecked;
                    if (!_isRoleChecked) _selectedRoles.clear();
                  });
                },
                text: localizations.addRole,
              ),
              if (_showRoles) ...[
                const SizedBox(height: 8),
                SizedBox(
                    height: 150,
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: roles.length,
                        itemBuilder: (context, index) {
                          final role = roles[index];
                          return CheckboxListTile(
                            title: Text(role.name),
                            value: _selectedRoles.contains(role.id),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedRoles.add(role.id);
                                } else {
                                  _selectedRoles.remove(role.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    )),
              ],
              const SizedBox(height: 16),
              CustomCheckbox(
                isChecked: _isPermissionChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isPermissionChecked = value ?? false;
                    _showPermissions = _isPermissionChecked;
                    if (!_isPermissionChecked) _selectedPermissions.clear();
                  });
                },
                text: localizations.addPermission,
              ),
              if (_showPermissions) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: Scrollbar(
                      child: ListView.builder(
                    itemCount: permissions.length,
                    itemBuilder: (context, index) {
                      final permission = permissions[index];
                      return CheckboxListTile(
                        title: Text(permission.name),
                        value: _selectedPermissions.contains(permission.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedPermissions.add(permission.id);
                            } else {
                              _selectedPermissions.remove(permission.id);
                            }
                          });
                        },
                      );
                    },
                  )),
                ),
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
                  : Center(
                      child: CustomButton(
                      text: localizations.createUserButton,
                      onPressed: _createUser,
                      width: 180,
                      height: 50,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
