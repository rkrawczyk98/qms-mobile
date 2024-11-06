class CreateRoleDto {
  final String name;

  CreateRoleDto({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}