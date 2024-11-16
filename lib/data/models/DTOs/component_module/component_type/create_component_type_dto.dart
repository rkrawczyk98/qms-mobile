class CreateComponentTypeDto {
  final String name;
  final int sortOrder;

  CreateComponentTypeDto({
    required this.name,
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sortOrder': sortOrder,
    };
  }
}
