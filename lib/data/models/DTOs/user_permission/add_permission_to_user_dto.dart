class AddPermissionToUserDto {
  final int userId;
  final int permissionId;

  AddPermissionToUserDto({
    required this.userId,
    required this.permissionId,
  });

  factory AddPermissionToUserDto.fromJson(Map<String, dynamic> json) {
    return AddPermissionToUserDto(
      userId: json['userId'] as int,
      permissionId: json['permissionId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'permissionId': permissionId,
    };
  }
}
