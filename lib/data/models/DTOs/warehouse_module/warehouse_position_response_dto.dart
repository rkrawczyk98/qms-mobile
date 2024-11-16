class WarehousePositionResponseDto {
  final int id;
  final String name;
  final int warehouseId;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  WarehousePositionResponseDto({
    required this.id,
    required this.name,
    required this.warehouseId,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory WarehousePositionResponseDto.fromJson(Map<String, dynamic> json) {
    return WarehousePositionResponseDto(
      id: json['id'],
      name: json['name'],
      warehouseId: json['warehouseId'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'warehouseId': warehouseId,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
