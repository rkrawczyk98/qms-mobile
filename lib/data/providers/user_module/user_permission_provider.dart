import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/permission/permission.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_permission/delete_permission_from_user.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import '../../models/DTOs/user_module/user_permission/add_permission_to_user_dto.dart';
import '../../services/user_module/user_permission_service.dart';

class UserPermissionNotifier extends StateNotifier<List<Permission>> {
  final UserPermissionService _userPermissionService;

  UserPermissionNotifier(this._userPermissionService) : super([]);

  // Get permissions for a given user
  Future<bool> loadPermissionsByRoleId(int userId) async {
    try {
      final permissions = await _userPermissionService.getPermissionsByUserId(userId);
      state = permissions ?? [];
      return true;
    } catch (e) {
      debugPrint("Error getting permissions for user $userId: $e");
      return false;
    }
  }

  Future<bool> addPermissionToUser(AddPermissionToUserDto dto) async {
    final success = await _userPermissionService.addPermissionToUser(dto);
    if (success) {
      await findPermissionsByUserId(dto.userId);
    }
    return success;
  }

  Future<bool> deletePermissionFromUser(DeletePermissionFromUserDto dto) async {
    final success = await _userPermissionService.deletePermissionFromUser(dto);
    if (success) {
      await findPermissionsByUserId(dto.userId);
    }
    return success;
  }

  Future<void> findPermissionsByUserId(int userId) async {
    state = await _userPermissionService.findPermissionsByUserId(userId);
  }
}

final userPermissionNotifierProvider = StateNotifierProvider<UserPermissionNotifier, List<Permission>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final userPermissionService = UserPermissionService(apiService);
  return UserPermissionNotifier(userPermissionService);
});

final userPermissionServiceProvider = Provider<UserPermissionService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return UserPermissionService(apiService);
});