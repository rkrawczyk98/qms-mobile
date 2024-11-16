class CreateSubcomponentStatusDto {
  final String name;

  CreateSubcomponentStatusDto({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
