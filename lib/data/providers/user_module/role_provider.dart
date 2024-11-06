import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role/create_role_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role/role.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/role/update_role_dto.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/user_module/role_service.dart';

class RoleNotifier extends StateNotifier<List<Role>> {
  final RoleService _roleService;

  RoleNotifier(this._roleService) : super([]) {
    loadRoles();
  }

  Future<void> loadRoles() async {
    state = await _roleService.getAllRoles();
  }

  Future<bool> addRole(CreateRoleDto roleDto) async {
    final success = await _roleService.createRole(roleDto);
    if (success) {
      await loadRoles();
      return true;
    }
    return false;
  }

  Future<bool> editRole(int roleId, UpdateRoleDto roleDto) async {
    final success = await _roleService.updateRole(roleId, roleDto);
    if (success) {
      await loadRoles();
      return true;
    }
    return false;
  }

  Future<bool> removeRole(int roleId) async {
    final success = await _roleService.deleteRole(roleId);
    if (success) {
      await loadRoles();
      return true;
    }
    return false;
  }
}

final roleNotifierProvider =
    StateNotifierProvider<RoleNotifier, List<Role>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final roleService = RoleService(apiService);
  return RoleNotifier(roleService);
});
