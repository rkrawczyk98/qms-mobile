class AddRoleToUserDto {
  final int userId;
  final int roleId;

  AddRoleToUserDto({
    required this.userId,
    required this.roleId,
  });

  factory AddRoleToUserDto.fromJson(Map<String, dynamic> json) {
    return AddRoleToUserDto(
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
