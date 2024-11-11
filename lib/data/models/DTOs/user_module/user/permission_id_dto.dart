class PermissionIdDto {
  final int permissionId;

  PermissionIdDto({required this.permissionId});

  factory PermissionIdDto.fromJson(Map<String, dynamic> json) {
    return PermissionIdDto(
      permissionId: json['permissionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permissionId': permissionId,
    };
  }
}
