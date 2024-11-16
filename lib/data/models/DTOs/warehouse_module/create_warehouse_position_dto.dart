class CreateWarehousePositionDto {
  final String name;
  final int warehouseId;

  CreateWarehousePositionDto({required this.name, required this.warehouseId});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'warehouseId': warehouseId,
    };
  }
}
