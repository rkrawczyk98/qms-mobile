import 'package:flutter/foundation.dart';
import 'package:qms_mobile/data/models/DTOs/role/create_role_dto.dart';
import 'package:qms_mobile/data/models/DTOs/role/role.dart';
import 'package:qms_mobile/data/models/DTOs/role/update_role_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class RoleService {
  final ApiService _apiService;

  RoleService(this._apiService);

  // Fetch all roles
  Future<List<Role>> getAllRoles() async {
    try {
      final response = await _apiService.dio.get('/roles');
      return (response.data as List).map((role) => Role.fromJson(role)).toList();
    } catch (e) {
      debugPrint("Failed to fetch roles: $e");
      return [];
    }
  }

  // Create a new role
  Future<bool> createRole(CreateRoleDto createRoleDto) async {
    try {
      await _apiService.dio.post('/roles', data: createRoleDto.toJson());
      return true;
    } catch (e) {
      debugPrint("Create role failed: $e");
      return false;
    }
  }

  // Update a role
  Future<bool> updateRole(int id, UpdateRoleDto updateRoleDto) async {
    try {
      await _apiService.dio.patch('/roles/$id', data: updateRoleDto.toJson());
      return true;
    } catch (e) {
      debugPrint("Update role failed: $e");
      return false;
    }
  }

  // Delete a role
  Future<bool> deleteRole(int id) async {
    try {
      await _apiService.dio.delete('/roles/$id');
      return true;
    } catch (e) {
      debugPrint("Delete role failed: $e");
      return false;
    }
  }
}
