class DeleteRoleFromUserDto {
  final int userId;
  final int roleId;

  DeleteRoleFromUserDto({
    required this.userId,
    required this.roleId,
  });

  factory DeleteRoleFromUserDto.fromJson(Map<String, dynamic> json) {
    return DeleteRoleFromUserDto(
      userId: json['userId'] as int,
      roleId: json['roleId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'roleId': roleId,
    };
  }
}
