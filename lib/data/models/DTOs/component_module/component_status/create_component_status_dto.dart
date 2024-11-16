class CreateComponentStatusDto {
  final String name;
  final bool isCountedForShipping;

  CreateComponentStatusDto({
    required this.name,
    required this.isCountedForShipping,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCountedForShipping': isCountedForShipping,
    };
  }
}
