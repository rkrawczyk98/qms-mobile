class UpdateComponentDto {
  final String? outsideNumber;
  final DateTime? shippingDate;
  final DateTime? controlDate;
  final DateTime? scrappedAt;
  final DateTime? productionDate;
  final String? nameOne;
  final String? nameTwo;
  final String? newMonNumber;
  final String? oldMonNumber;
  final int? size;
  final String? wzNumber;

  UpdateComponentDto({
    this.outsideNumber,
    this.shippingDate,
    this.controlDate,
    this.scrappedAt,
    this.productionDate,
    this.nameOne,
    this.nameTwo,
    this.newMonNumber,
    this.oldMonNumber,
    this.size,
    this.wzNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'outsideNumber': outsideNumber,
      'shippingDate': shippingDate?.toIso8601String(),
      'controlDate': controlDate?.toIso8601String(),
      'scrappedAt': scrappedAt?.toIso8601String(),
      'productionDate': productionDate?.toIso8601String(),
      'nameOne': nameOne,
      'nameTwo': nameTwo,
      'newMonNumber': newMonNumber,
      'oldMonNumber': oldMonNumber,
      'size': size,
      'wzNumber': wzNumber,
    };
  }
}
