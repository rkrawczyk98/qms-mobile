class DeletePermissionFromUserDto {
  final int userId;
  final int permissionId;

  DeletePermissionFromUserDto({
    required this.userId,
    required this.permissionId,
  });

  factory DeletePermissionFromUserDto.fromJson(Map<String, dynamic> json) {
    return DeletePermissionFromUserDto(
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
