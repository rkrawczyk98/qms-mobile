class UpdateWarehouseDto {
  final String? name;

  UpdateWarehouseDto({this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
