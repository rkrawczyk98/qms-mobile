class UpdateDeliveryStatusDto {
  final String? name;

  UpdateDeliveryStatusDto({this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
