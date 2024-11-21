class CreateDeliveryStatusDto {
  final String name;

  CreateDeliveryStatusDto({required this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
