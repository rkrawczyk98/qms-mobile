import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/permission/create_permission_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/permission/permission.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/permission/update_permission_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role/create_role_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role/update_role_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role_permission/add_permission_to_role_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role_permission/delete_permission_from_role_dto.dart';
import 'package:qms_mobile/data/providers/user_module/permission_provider.dart';
import 'package:qms_mobile/data/providers/user_module/role_permission_provider.dart';
import 'package:qms_mobile/data/providers/user_module/role_provider.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RolePermissionManagementScreen extends ConsumerStatefulWidget {
  const RolePermissionManagementScreen({super.key});

  @override
  RolePermissionManagementScreenState createState() =>
      RolePermissionManagementScreenState();
}

class RolePermissionManagementScreenState
    extends ConsumerState<RolePermissionManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        ref.read(roleNotifierProvider.notifier).loadRoles();
      } else if (_tabController.index == 1) {
        ref.read(permissionNotifierProvider.notifier).loadPermissions();
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _createRole() async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return;

    final roleName = await _showInputDialog(
        context, AppLocalizations.of(context)!.enterRoleName);
    if (roleName == null || roleName.isEmpty) return;

    final success = await ref
        .read(roleNotifierProvider.notifier)
        .addRole(CreateRoleDto(name: roleName));
    if (mounted && success) {
      CustomSnackbar.showSuccessSnackbar(
        context,
        AppLocalizations.of(context)!.roleCreated,
      );
    }
  }

  Future<void> _createPermission() async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return;

    final permissionName = await _showInputDialog(
        context, AppLocalizations.of(context)!.enterPermissionName);
    if (permissionName == null || permissionName.isEmpty) return;

    final success = await ref
        .read(permissionNotifierProvider.notifier)
        .addPermission(CreatePermissionDto(name: permissionName));
    if (mounted && success) {
      CustomSnackbar.showSuccessSnackbar(
        context,
        AppLocalizations.of(context)!.permissionCreated,
      );
    }
  }

  Future<void> _editRole(int roleId, String currentName) async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return;

    final newRoleName = await _showInputDialog(
        context, AppLocalizations.of(context)!.editRoleName, currentName);
    if (newRoleName == null || newRoleName.isEmpty) return;

    final success = await ref
        .read(roleNotifierProvider.notifier)
        .editRole(roleId, UpdateRoleDto(name: newRoleName));
    if (mounted && success) {
      CustomSnackbar.showSuccessSnackbar(
        context,
        AppLocalizations.of(context)!.roleUpdated,
      );
    }
  }

  Future<void> _managePermissionsForRole(
      BuildContext context, int roleId) async {
    final rolePermissionService = ref.read(rolePermissionServiceProvider);
    final assignedPermissions =
        await rolePermissionService.getPermissionsByRoleId(roleId);
    final allPermissions = ref.watch(permissionNotifierProvider);

    final TextEditingController searchController = TextEditingController();
    List<Permission> filteredPermissions = List.from(allPermissions);

    List<int> selectedPermissions =
        assignedPermissions?.map((p) => p.id).toList() ?? [];

    void filterPermissions(String query) {
      setState(() {
        filteredPermissions = allPermissions
            .where((permission) =>
                permission.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
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
                        labelText:
                            AppLocalizations.of(context)!.searchPermissions,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
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
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredPermissions.length,
                        itemBuilder: (context, index) {
                          final permission = filteredPermissions[index];
                          return CheckboxListTile(
                            title: Text(permission.name),
                            value: selectedPermissions.contains(permission.id),
                            onChanged: (bool? isChecked) {
                              setState(() {
                                if (isChecked == true) {
                                  selectedPermissions.add(permission.id);
                                  rolePermissionService.addPermissionToRole(
                                    AddPermissionToRoleDto(
                                      roleId: roleId,
                                      permissionId: permission.id,
                                    ),
                                  );
                                } else {
                                  selectedPermissions.remove(permission.id);
                                  rolePermissionService
                                      .deletePermissionFromRole(
                                    DeletePermissionFromRoleDto(
                                      roleId: roleId,
                                      permissionId: permission.id,
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
                        color: Theme.of(context).textTheme.bodySmall?.color),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _editPermission(int permissionId, String currentName) async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return;

    final newPermissionName = await _showInputDialog(
        context, AppLocalizations.of(context)!.editPermissionName, currentName);
    if (newPermissionName == null || newPermissionName.isEmpty) return;

    final success = await ref
        .read(permissionNotifierProvider.notifier)
        .editPermission(
            permissionId, UpdatePermissionDto(name: newPermissionName));
    if (mounted && success) {
      CustomSnackbar.showSuccessSnackbar(
        context,
        AppLocalizations.of(context)!.permissionUpdated,
      );
    }
  }

  Future<void> _deleteRole(int roleId) async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return;

    // Show confirmation box
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDeletion),
          content: Text(AppLocalizations.of(context)!.confirmDeleteRole),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.delete,
                  style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    // Delete role after confirmation
    final success =
        await ref.read(roleNotifierProvider.notifier).removeRole(roleId);
    if (mounted && success) {
      CustomSnackbar.showSuccessSnackbar(
        context,
        AppLocalizations.of(context)!.roleDeleted,
      );
    }
  }

  Future<void> _deletePermission(int permissionId) async {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return;

    // Show confirmation box
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDeletion),
          content: Text(AppLocalizations.of(context)!.confirmDeletePermission),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.delete,
                  style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    // Remove permission after confirmation
    final success = await ref
        .read(permissionNotifierProvider.notifier)
        .removePermission(permissionId);
    if (mounted && success) {
      CustomSnackbar.showSuccessSnackbar(
        context,
        AppLocalizations.of(context)!.permissionDeleted,
      );
    }
  }

  Future<String?> _showInputDialog(BuildContext context, String title,
      [String? initialValue]) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(AppLocalizations.of(context)!.cancel,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(AppLocalizations.of(context)!.ok,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rolePermissionManagement),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.roles),
            Tab(text: AppLocalizations.of(context)!.permissions),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRolesTab(context),
          _buildPermissionsTab(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _createRole();
          } else {
            _createPermission();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRolesTab(BuildContext context) {
    final roles = ref.watch(roleNotifierProvider);

    return roles.isEmpty
        ? Center(child: Text(AppLocalizations.of(context)!.noRolesFound))
        : ListView.builder(
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return ListTile(
                title: Text(role.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.security),
                      onPressed: () =>
                          _managePermissionsForRole(context, role.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editRole(role.id, role.name),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteRole(role.id),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildPermissionsTab(BuildContext context) {
    final permissions = ref.watch(permissionNotifierProvider);

    return permissions.isEmpty
        ? Center(child: Text(AppLocalizations.of(context)!.noPermissionsFound))
        : ListView.builder(
            itemCount: permissions.length,
            itemBuilder: (context, index) {
              final permission = permissions[index];
              return ListTile(
                title: Text(permission.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _editPermission(permission.id, permission.name),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deletePermission(permission.id),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
