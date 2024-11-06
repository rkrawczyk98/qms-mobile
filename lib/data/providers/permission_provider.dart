import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/permission/create_permission_dto.dart';
import 'package:qms_mobile/data/models/DTOs/permission/permission.dart';
import 'package:qms_mobile/data/models/DTOs/permission/update_permission_dto.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/permission_service.dart';

class PermissionNotifier extends StateNotifier<List<Permission>> {
  final PermissionService _permissionService;

  PermissionNotifier(this._permissionService) : super([]) {
    loadPermissions();
  }

  Future<void> loadPermissions() async {
    state = await _permissionService.findAllPermissions();
  }

  Future<bool> addPermission(CreatePermissionDto permissionDto) async {
    final success = await _permissionService.createPermission(permissionDto);
    if (success) {
      await loadPermissions();
      return true;
    }
    return false;
  }

  Future<bool> editPermission(
      int permissionId, UpdatePermissionDto permissionDto) async {
    final success =
        await _permissionService.updatePermission(permissionId, permissionDto);
    if (success) {
      await loadPermissions();
      return true;
    }
    return false;
  }

  Future<bool> removePermission(int permissionId) async {
    final success = await _permissionService.deletePermission(permissionId);
    if (success) {
      await loadPermissions();
      return true;
    }
    return false;
  }
}

final permissionNotifierProvider =
    StateNotifierProvider<PermissionNotifier, List<Permission>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final permissionService = PermissionService(apiService);
  return PermissionNotifier(permissionService);
});
