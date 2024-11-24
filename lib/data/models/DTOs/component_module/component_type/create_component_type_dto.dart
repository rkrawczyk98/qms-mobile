class CreateComponentTypeDto {
  final String name;

  CreateComponentTypeDto({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name
    };
  }
}
