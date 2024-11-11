import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/models/DTOs/auth_module/user_info.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/permission/permission.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role/role.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user/user_role_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_permission/add_permission_to_user_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_permission/delete_permission_from_user.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_role/add_role_to_user_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_role/delete_role_from_user_dto.dart';
import 'package:qms_mobile/data/providers/user_module/permission_provider.dart';
import 'package:qms_mobile/data/providers/user_module/role_provider.dart';
import 'package:qms_mobile/data/providers/user_module/user_permission_provider.dart';
import 'package:qms_mobile/data/providers/user_module/user_provider.dart';
import 'package:qms_mobile/data/providers/user_module/user_role_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';
import 'package:qms_mobile/views/widgets/section_card.dart';

class ManageUserScreen extends ConsumerStatefulWidget {
  const ManageUserScreen({super.key});

  @override
  ConsumerState<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends ConsumerState<ManageUserScreen> {
  List<UserRoleResponseDto>? usersWithRoles;
  UserInfo? selectedUser;
  List<Role>? availableRoles;
  List<Permission>? availablePermissions;
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsersWithRoles();
    _fetchAvailableRoles();
    _fetchAvailablePermissions();
  }

  Future<void> _fetchUsersWithRoles() async {
    final userService = ref.read(userServiceProvider);
    final users = await userService.getUsersWithRoles();
    setState(() {
      usersWithRoles = users?.cast<UserRoleResponseDto>();
    });
  }

  Future<void> _fetchAvailableRoles() async {
    final roleService = ref.read(roleServiceProvider);
    final roles = await roleService.getAllRoles();
    setState(() {
      availableRoles = roles;
    });
  }

  Future<void> _fetchAvailablePermissions() async {
    final permissionService = ref.read(permissionServiceProvider);
    final permissions = await permissionService.findAllPermissions();
    setState(() {
      availablePermissions = permissions;
    });
  }

  Future<void> _fetchUserInfo(int userId) async {
    final userService = ref.read(userServiceProvider);
    final userRoleService = ref.read(userRoleServiceProvider);
    final userPermissionService = ref.read(userPermissionServiceProvider);

    final userInfo = await userService.fetchUserInfo(userId: userId);
    final userRoles = await userRoleService.findAllRolesForUser(userId);
    final userPermissions =
        await userPermissionService.findPermissionsByUserId(userId);

    if (!mounted) return;

    setState(() {
      selectedUser = userInfo;
      availableRoles = userRoles;
      availablePermissions = userPermissions;
    });
  }

  Future<void> _manageRolesForUser(BuildContext context) async {
    final userRoleService = ref.read(userRoleServiceProvider);
    final allRoles = ref.watch(roleNotifierProvider);
    final assignedRoles = availableRoles?.map((role) => role.id).toList() ?? [];

    final TextEditingController searchController = TextEditingController();
    List<Role> filteredRoles = List.from(allRoles);

    void filterRoles(String query) {
      filteredRoles = allRoles
          .where(
              (role) => role.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.manageRoles),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search roles',
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                        prefixIcon: Icon(Icons.search,
                            color: Theme.of(context).hintColor),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.05),
                      ),
                      onChanged: (query) {
                        setState(() {
                          filterRoles(query);
                        });
                      },
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredRoles.length,
                        itemBuilder: (context, index) {
                          final role = filteredRoles[index];
                          return CheckboxListTile(
                            title: Text(role.name),
                            value: assignedRoles.contains(role.id),
                            onChanged: (bool? isChecked) {
                              setState(() {
                                if (isChecked == true) {
                                  assignedRoles.add(role.id);
                                  userRoleService.addRoleToUser(
                                    AddRoleToUserDto(
                                      userId: selectedUser!.id,
                                      roleId: role.id,
                                    ),
                                  );
                                } else {
                                  assignedRoles.remove(role.id);
                                  userRoleService.deleteRoleFromUser(
                                    DeleteRoleFromUserDto(
                                      userId: selectedUser!.id,
                                      roleId: role.id,
                                    ),
                                  );
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.close,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    await _fetchUserInfo(selectedUser!.id);
  }

  Future<void> _managePermissionsForUser(BuildContext context) async {
    final userPermissionService = ref.read(userPermissionServiceProvider);
    final allPermissions = ref.watch(permissionNotifierProvider);
    final assignedPermissions =
        availablePermissions?.map((perm) => perm.id).toList() ?? [];

    final TextEditingController searchController = TextEditingController();
    List<Permission> filteredPermissions = List.from(allPermissions);

    void filterPermissions(String query) {
      filteredPermissions = allPermissions
          .where((permission) =>
              permission.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.managePermissions),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search permissions',
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).hintColor,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.05),
                      ),
                      onChanged: (query) {
                        setState(() {
                          filterPermissions(query);
                        });
                      },
                      cursorColor: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredPermissions.length,
                        itemBuilder: (context, index) {
                          final permission = filteredPermissions[index];
                          return CheckboxListTile(
                            title: Text(permission.name),
                            value: assignedPermissions.contains(permission.id),
                            onChanged: (bool? isChecked) {
                              setState(() {
                                if (isChecked == true) {
                                  assignedPermissions.add(permission.id);
                                  userPermissionService.addPermissionToUser(
                                      AddPermissionToUserDto(
                                          userId: selectedUser!.id,
                                          permissionId: permission.id));
                                } else {
                                  assignedPermissions.remove(permission.id);
                                  userPermissionService
                                      .deletePermissionFromUser(
                                          DeletePermissionFromUserDto(
                                              userId: selectedUser!.id,
                                              permissionId: permission.id));
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.close,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    await _fetchUserInfo(
        selectedUser!.id);
  }

  Future<void> _resetPassword() async {
    if (selectedUser == null || passwordController.text.isEmpty) return;

    final userService = ref.read(userServiceProvider);
    final success = await userService.resetPassword(
      selectedUser!.id,
      passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      CustomSnackbar.showSuccessSnackbar(
        context,
        AppLocalizations.of(context)!.passwordResetSuccess,
      );
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.userManagementTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<UserRoleResponseDto>(
              decoration: InputDecoration(
                labelText: localizations.selectUser,
                border: const OutlineInputBorder(),
              ),
              items: usersWithRoles?.map((user) {
                return DropdownMenuItem<UserRoleResponseDto>(
                  value: user,
                  child: Text(user.user.username),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUser = null;
                });
                if (value != null) {
                  _fetchUserInfo(value.user.id);
                }
              },
            ),
            if (selectedUser != null) ...[
              SectionCard(
                title: localizations.roles,
                icon: Icons.account_circle,
                content: availableRoles
                        ?.map((role) => Chip(label: Text(role.name)))
                        .toList() ??
                    [],
                onManagePressed: () => _manageRolesForUser(context),
                manageLabel: localizations.manage,
              ),
              SectionCard(
                title: localizations.permissions,
                icon: Icons.security,
                content: availablePermissions
                        ?.map((perm) => Chip(label: Text(perm.name)))
                        .toList() ??
                    [],
                onManagePressed: () => _managePermissionsForUser(context),
                manageLabel: localizations.manage,
              ),
              _buildPasswordResetCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordResetCard(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SectionCard(
      title: localizations.resetPassword,
      icon: Icons.lock_reset_outlined,
      content: [
        CustomTextField(
          label: localizations.newPassword,
          hint: localizations.enterNewPassword,
          isObscure: true,
          controller: passwordController,
        ),
      ],
      onManagePressed: _resetPassword,
      manageLabel: localizations.reset,
    );
  }
}
