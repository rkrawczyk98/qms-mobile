import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/permission/permission.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role_permission/add_permission_to_role_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role_permission/delete_permission_from_role_dto.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/user_module/role_permission_service.dart';

class RolePermissionNotifier extends StateNotifier<List<Permission>> {
  final RolePermissionService _rolePermissionService;

  RolePermissionNotifier(this._rolePermissionService) : super([]);

  // Get permissions for a given role
  Future<bool> loadPermissionsByRoleId(int roleId) async {
    try {
      final permissions = await _rolePermissionService.getPermissionsByRoleId(roleId);
      state = permissions ?? [];
      return true;
    } catch (e) {
      debugPrint("Error getting permissions for role $roleId: $e");
      return false;
    }
  }

  // Add permission to role
  Future<bool> addPermissionToRole(AddPermissionToRoleDto dto) async {
    try {
      final success = await _rolePermissionService.addPermissionToRole(dto);
      if (success) {
        await loadPermissionsByRoleId(dto.roleId);
      }
      return success;
    } catch (e) {
      debugPrint("Error adding permission to role: $e");
      return false;
    }
  }

  // Remove permission from role
  Future<bool> deletePermissionFromRole(DeletePermissionFromRoleDto dto) async {
    try {
      final success = await _rolePermissionService.deletePermissionFromRole(dto);
      if (success) {
        await loadPermissionsByRoleId(dto.roleId);
      }
      return success;
    } catch (e) {
      debugPrint("Error removing permission from role: $e");
      return false;
    }
  }
}

final rolePermissionNotifierProvider = StateNotifierProvider<RolePermissionNotifier, List<Permission>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final rolePermissionService = RolePermissionService(apiService);
  return RolePermissionNotifier(rolePermissionService);
});
