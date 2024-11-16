class ComponentResponseDto {
  final int id;
  final String nameOne;
  final String? nameTwo;
  final String insideNumber;
  final String outsideNumber;
  final String createdByUsername;
  final String modifiedByUsername;
  final String componentTypeName;
  final String statusName;
  final String? deliveryNumber;
  final String? warehouseName;
  final String? warehousePositionName;
  final DateTime? productionDate;
  final DateTime? controlDate;
  final int size;
  final String newMonNumber;
  final String? oldMonNumber;
  final DateTime creationDate;
  final DateTime? shippingDate;
  final DateTime? scrappedAt;
  final DateTime lastModified;
  final DateTime? deletedAt;

  ComponentResponseDto({
    required this.id,
    required this.nameOne,
    this.nameTwo,
    required this.insideNumber,
    required this.outsideNumber,
    required this.createdByUsername,
    required this.modifiedByUsername,
    required this.componentTypeName,
    required this.statusName,
    this.deliveryNumber,
    this.warehouseName,
    this.warehousePositionName,
    this.productionDate,
    this.controlDate,
    required this.size,
    required this.newMonNumber,
    this.oldMonNumber,
    required this.creationDate,
    this.shippingDate,
    this.scrappedAt,
    required this.lastModified,
    this.deletedAt,
  });

  factory ComponentResponseDto.fromJson(Map<String, dynamic> json) {
    return ComponentResponseDto(
      id: json['id'],
      nameOne: json['nameOne'],
      nameTwo: json['nameTwo'],
      insideNumber: json['insideNumber'],
      outsideNumber: json['outsideNumber'],
      createdByUsername: json['createdByUsername'],
      modifiedByUsername: json['modifiedByUsername'],
      componentTypeName: json['componentTypeName'],
      statusName: json['statusName'],
      deliveryNumber: json['deliveryNumber'],
      warehouseName: json['warehouseName'],
      warehousePositionName: json['warehousePositionName'],
      productionDate: json['productionDate'] != null
          ? DateTime.parse(json['productionDate'])
          : null,
      controlDate: json['controlDate'] != null
          ? DateTime.parse(json['controlDate'])
          : null,
      size: json['size'],
      newMonNumber: json['newMonNumber'],
      oldMonNumber: json['oldMonNumber'],
      creationDate: DateTime.parse(json['creationDate']),
      shippingDate: json['shippingDate'] != null
          ? DateTime.parse(json['shippingDate'])
          : null,
      scrappedAt: json['scrappedAt'] != null
          ? DateTime.parse(json['scrappedAt'])
          : null,
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameOne': nameOne,
      'nameTwo': nameTwo,
      'insideNumber': insideNumber,
      'outsideNumber': outsideNumber,
      'createdByUsername': createdByUsername,
      'modifiedByUsername': modifiedByUsername,
      'componentTypeName': componentTypeName,
      'statusName': statusName,
      'deliveryNumber': deliveryNumber,
      'warehouseName': warehouseName,
      'warehousePositionName': warehousePositionName,
      'productionDate': productionDate?.toIso8601String(),
      'controlDate': controlDate?.toIso8601String(),
      'size': size,
      'newMonNumber': newMonNumber,
      'oldMonNumber': oldMonNumber,
      'creationDate': creationDate.toIso8601String(),
      'shippingDate': shippingDate?.toIso8601String(),
      'scrappedAt': scrappedAt?.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
