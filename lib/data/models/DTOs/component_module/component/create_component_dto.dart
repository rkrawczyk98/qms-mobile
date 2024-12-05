class CreateComponentDto {
  final String nameOne;
  final String? nameTwo;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final int? deliveryId;
  final double size;

  CreateComponentDto({
    required this.nameOne,
    this.nameTwo,
    this.controlDate,
    this.productionDate,
    this.deliveryId,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'nameOne': nameOne,
      'nameTwo': nameTwo,
      'controlDate': controlDate?.toIso8601String(),
      'productionDate': productionDate?.toIso8601String(),
      'deliveryId': deliveryId,
      'size': size,
    };
  }
}
