class CreatePermissionDto {
  final String name;

  CreatePermissionDto({required this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
