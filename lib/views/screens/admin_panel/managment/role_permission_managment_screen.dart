import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/permission/create_permission_dto.dart';
import 'package:qms_mobile/data/models/DTOs/permission/update_permission_dto.dart';
import 'package:qms_mobile/data/models/DTOs/role/create_role_dto.dart';
import 'package:qms_mobile/data/models/DTOs/role/update_role_dto.dart';
import 'package:qms_mobile/data/providers/permission_provider.dart';
import 'package:qms_mobile/data/providers/role_provider.dart';
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
  }

  @override
  void dispose() {
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
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(AppLocalizations.of(context)!.ok),
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
