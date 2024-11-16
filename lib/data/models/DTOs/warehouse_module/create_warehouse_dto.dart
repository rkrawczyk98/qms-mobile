class CreateWarehouseDto {
  final String name;

  CreateWarehouseDto({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
