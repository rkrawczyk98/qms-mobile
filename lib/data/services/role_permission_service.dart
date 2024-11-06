import 'package:flutter/foundation.dart';
import 'package:qms_mobile/data/models/DTOs/permission/permission.dart';
import 'package:qms_mobile/data/models/DTOs/role_permission/add_permission_to_role_dto.dart';
import 'package:qms_mobile/data/models/DTOs/role_permission/delete_permission_from_role_dto.dart';
import 'api_service.dart';

class RolePermissionService {
  final ApiService _apiService;

  RolePermissionService(this._apiService);

  Future<bool> addPermissionToRole(AddPermissionToRoleDto dto) async {
    try {
      final response =
          await _apiService.dio.post('/role-permissions', data: dto.toJson());
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Failed to add permission to role: $e');
      return false;
    }
  }

  Future<bool> deletePermissionFromRole(DeletePermissionFromRoleDto dto) async {
    try {
      final response =
          await _apiService.dio.delete('/role-permissions', data: dto.toJson());
      return response.statusCode == 204;
    } catch (e) {
      debugPrint('Failed to delete permission from role: $e');
      return false;
    }
  }

  Future<List<Permission>?> getPermissionsByRoleId(int roleId) async {
    try {
      final response = await _apiService.dio.get('/role-permissions/$roleId/permissions');
      final permissions = (response.data as List)
          .map((permissionJson) => Permission.fromJson(permissionJson))
          .toList();
      return permissions;
    } catch (e) {
      debugPrint("Error getting permissions for role $roleId: $e");
      return null;
    }
  }
}
