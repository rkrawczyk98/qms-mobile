class AddPermissionToRoleDto {
  final int roleId;
  final int permissionId;

  AddPermissionToRoleDto({
    required this.roleId,
    required this.permissionId,
  });

  factory AddPermissionToRoleDto.fromJson(Map<String, dynamic> json) {
    return AddPermissionToRoleDto(
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
