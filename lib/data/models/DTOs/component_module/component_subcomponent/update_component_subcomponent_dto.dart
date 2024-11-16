class UpdateComponentSubcomponentDto {
  final int statusId;

  UpdateComponentSubcomponentDto({
    required this.statusId,
  });

  Map<String, dynamic> toJson() {
    return {
      'statusId': statusId,
    };
  }
}
