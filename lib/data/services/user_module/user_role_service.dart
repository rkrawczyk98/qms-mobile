import 'package:flutter/material.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role/role.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_role/add_role_to_user_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_role/delete_role_from_user_dto.dart';
import '../api_service.dart';

class UserRoleService {
  final ApiService _apiService;

  UserRoleService(this._apiService);

  Future<bool> addRoleToUser(AddRoleToUserDto dto) async {
    try {
      await _apiService.dio.post('/user-roles', data: dto.toJson());
      return true;
    } catch (e) {
      debugPrint("Error adding role to user: $e");
      return false;
    }
  }

  Future<bool> deleteRoleFromUser(DeleteRoleFromUserDto dto) async {
    try {
      await _apiService.dio.delete('/user-roles', data: dto.toJson());
      return true;
    } catch (e) {
      debugPrint("Error removing role from user: $e");
      return false;
    }
  }

  Future<List<Role>?> findAllRolesForUser(int userId) async {
    try {
      final response = await _apiService.dio.get('/user-roles/$userId/roles');
      return (response.data as List)
          .map((item) => Role.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint("Error getting user roles: $e");
      return null;
    }
  }
}
