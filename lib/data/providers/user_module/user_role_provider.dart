import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_role/user_role_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_role/add_role_to_user_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user_role/delete_role_from_user_dto.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/user_module/user_role_service.dart';

class UserRoleNotifier extends StateNotifier<List<UserRoleResponseDto>> {
  final UserRoleService _userRoleService;

  UserRoleNotifier(this._userRoleService) : super([]);

  Future<void> loadRolesForUser(int userId) async {
    final roles = await _userRoleService.findAllRolesForUser(userId);
    if (roles != null) {
      state = roles;
    }
  }

  Future<bool> addRoleToUser(AddRoleToUserDto dto) async {
    final success = await _userRoleService.addRoleToUser(dto);
    if (success) {
      await loadRolesForUser(dto.userId);
    }
    return success;
  }

  Future<bool> deleteRoleFromUser(DeleteRoleFromUserDto dto) async {
    final success = await _userRoleService.deleteRoleFromUser(dto);
    if (success) {
      await loadRolesForUser(dto.userId);
    }
    return success;
  }
}

final userRoleNotifierProvider = StateNotifierProvider<UserRoleNotifier, List<UserRoleResponseDto>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final userRoleService = UserRoleService(apiService);
  return UserRoleNotifier(userRoleService);
});
