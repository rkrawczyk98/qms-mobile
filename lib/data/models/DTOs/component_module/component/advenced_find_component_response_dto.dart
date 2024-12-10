class AdvencedFindComponentResponseDto {
  final int id;
  final String nameOne;
  final String? nameTwo;
  final String insideNumber;
  final String? outsideNumber;
  final String createdByUsername;
  final String modifiedByUsername;
  final String componentTypeName;
  final String statusName;
  final String deliveryNumber;
  final String? warehouseName;
  final String? warehousePositionName;
  final DateTime? productionDate;
  final DateTime? controlDate;
  final double size;
  final DateTime creationDate;
  final DateTime? shippingDate;
  final DateTime? scrappedAt;
  final DateTime lastModified;
  final DateTime? deletedAt;
  final String? wzNumber;

  AdvencedFindComponentResponseDto({
    required this.id,
    required this.nameOne,
    this.nameTwo,
    required this.insideNumber,
    this.outsideNumber,
    required this.createdByUsername,
    required this.modifiedByUsername,
    required this.componentTypeName,
    required this.statusName,
    required this.deliveryNumber,
    this.warehouseName,
    this.warehousePositionName,
    this.productionDate,
    this.controlDate,
    required this.size,
    required this.creationDate,
    this.shippingDate,
    this.scrappedAt,
    required this.lastModified,
    this.deletedAt,
    this.wzNumber,
  });

  factory AdvencedFindComponentResponseDto.fromJson(Map<String, dynamic> json) {
    return AdvencedFindComponentResponseDto(
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
      size: double.parse(json['size'].toString()),
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
      wzNumber: json['wzNumber'],
    );
  }
}
