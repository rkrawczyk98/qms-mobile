class CreateComponentDto {
  final String nameOne;
  final String? nameTwo;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final int? deliveryId;
  final String newMonNumber;
  final String? oldMonNumber;
  final int size;

  CreateComponentDto({
    required this.nameOne,
    this.nameTwo,
    this.controlDate,
    this.productionDate,
    this.deliveryId,
    required this.newMonNumber,
    this.oldMonNumber,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'nameOne': nameOne,
      'nameTwo': nameTwo,
      'controlDate': controlDate?.toIso8601String(),
      'productionDate': productionDate?.toIso8601String(),
      'deliveryId': deliveryId,
      'newMonNumber': newMonNumber,
      'oldMonNumber': oldMonNumber,
      'size': size,
    };
  }
}
