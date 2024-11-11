import 'package:qms_mobile/data/models/DTOs/user_module/user/create_user_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user/permission_id_dto.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user/role_id_dto.dart';

class CreateUserWithRolesAndPermissionsDto {
  final CreateUserDto user;
  final List<RoleIdDto>? roles;
  final List<PermissionIdDto>? permissions;

  CreateUserWithRolesAndPermissionsDto({
    required this.user,
    this.roles,
    this.permissions,
  });

  Map<String, dynamic> toJson() {
    return {
      'createUserDto': user,
      'roles': roles?.map((role) => role.toJson()).toList(),
      'permissions': permissions?.map((perm) => perm.toJson()).toList(),
    };
  }
}
