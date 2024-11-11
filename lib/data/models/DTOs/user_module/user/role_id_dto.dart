class RoleIdDto {
  final int roleId;

  RoleIdDto({required this.roleId});

  factory RoleIdDto.fromJson(Map<String, dynamic> json) {
    return RoleIdDto(
      roleId: json['roleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
    };
  }
}
