class UpdateDeliveryDto {
  final String? number;
  final int? statusId;
  final int? customerId;
  final DateTime? deliveryDate;

  UpdateDeliveryDto({
    this.number,
    this.statusId,
    this.customerId,
    this.deliveryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'statusId': statusId,
      'customerId': customerId,
      'deliveryDate': deliveryDate?.toIso8601String(),
    };
  }
}
