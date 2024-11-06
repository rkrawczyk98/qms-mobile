import 'package:flutter/material.dart';
import 'package:qms_mobile/data/models/DTOs/permission/permission.dart';
import 'package:qms_mobile/data/models/DTOs/user_permission/delete_permission_from_user.dart';
import 'package:qms_mobile/data/services/api_service.dart';
import '../models/DTOs/user_permission/add_permission_to_user_dto.dart';

class UserPermissionService {
  final ApiService _apiService;

  UserPermissionService(this._apiService);

  Future<bool> addPermissionToUser(AddPermissionToUserDto dto) async {
    try {
      final response = await _apiService.dio.post('/user-permissions', data: dto.toJson());
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePermissionFromUser(DeletePermissionFromUserDto dto) async {
    try {
      final response = await _apiService.dio.delete('/user-permissions', data: dto.toJson());
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  Future<List<Permission>> findPermissionsByUserId(int userId) async {
    try {
      final response = await _apiService.dio.get('/user-permissions/$userId');
      return (response.data as List)
          .map((json) => Permission.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

    Future<List<Permission>?> getPermissionsByUserId(int userId) async {
    try {
      final response = await _apiService.dio.get('/user-permissions/$userId/user-permissions');
      final permissions = (response.data as List)
          .map((permissionJson) => Permission.fromJson(permissionJson))
          .toList();
      return permissions;
    } catch (e) {
      debugPrint("Error getting permissions for user $userId: $e");
      return null;
    }
  }
}
