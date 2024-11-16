class UpdateWarehousePositionDto {
  final String? name;
  final int? warehouseId;

  UpdateWarehousePositionDto({this.name, this.warehouseId});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'warehouseId': warehouseId,
    };
  }
}
