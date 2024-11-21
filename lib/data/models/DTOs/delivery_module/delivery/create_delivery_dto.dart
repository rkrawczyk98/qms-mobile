class CreateDeliveryDto {
  final int componentTypeId;
  final int customerId;
  final DateTime deliveryDate;

  CreateDeliveryDto({
    required this.componentTypeId,
    required this.customerId,
    required this.deliveryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'componentTypeId': componentTypeId,
      'customerId': customerId,
      'deliveryDate': deliveryDate.toIso8601String(),
    };
  }
}
