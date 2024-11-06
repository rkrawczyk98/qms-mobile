import 'package:flutter/foundation.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/permission/create_permission_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/permission/permission.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/permission/update_permission_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class PermissionService {
  final ApiService _apiService;

  PermissionService(this._apiService);

  // Create a new permission
  Future<bool> createPermission(CreatePermissionDto createPermissionDto) async {
    try {
      await _apiService.dio.post('/permissions', data: createPermissionDto.toJson());
      return true;
    } catch (e) {
      debugPrint('Failed to create permission: $e');
      return false;
    }
  }

  // Get all permissions
  Future<List<Permission>> findAllPermissions() async {
    try {
      final response = await _apiService.dio.get('/permissions');
      return (response.data as List).map((p) => Permission.fromJson(p)).toList();
    } catch (e) {
      debugPrint('Failed to fetch permissions: $e');
      return [];
    }
  }

  // Update a permission by ID
  Future<bool> updatePermission(int id, UpdatePermissionDto updatePermissionDto) async {
    try {
      await _apiService.dio.patch('/permissions/$id', data: updatePermissionDto.toJson());
      return true;
    } catch (e) {
      debugPrint('Failed to update permission with ID $id: $e');
      return false;
    }
  }

  // Delete a permission by ID
  Future<bool> deletePermission(int id) async {
    try {
      await _apiService.dio.delete('/permissions/$id');
      return true;
    } catch (e) {
      debugPrint('Failed to delete permission with ID $id: $e');
      return false;
    }
  }
}
