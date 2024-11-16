class UpdateSubcomponentPrimaryStatusDto {
  final int sortOrder;

  UpdateSubcomponentPrimaryStatusDto({
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'sortOrder': sortOrder,
    };
  }
}
