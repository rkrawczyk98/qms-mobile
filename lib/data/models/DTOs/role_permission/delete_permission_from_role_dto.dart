class DeletePermissionFromRoleDto {
  final int roleId;
  final int permissionId;

  DeletePermissionFromRoleDto({
    required this.roleId,
    required this.permissionId,
  });

  factory DeletePermissionFromRoleDto.fromJson(Map<String, dynamic> json) {
    return DeletePermissionFromRoleDto(
      roleId: json['roleId'] as int,
      permissionId: json['permissionId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
      'permissionId': permissionId,
    };
  }
}
