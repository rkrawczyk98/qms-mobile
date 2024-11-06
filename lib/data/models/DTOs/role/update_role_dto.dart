class UpdateRoleDto {
  final String? name;

  UpdateRoleDto({this.name});

  Map<String, dynamic> toJson() => {'name': name};
}