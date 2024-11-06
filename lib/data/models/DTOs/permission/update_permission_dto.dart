// update_permission_dto.dart
class UpdatePermissionDto {
  final String? name;

  UpdatePermissionDto({this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
