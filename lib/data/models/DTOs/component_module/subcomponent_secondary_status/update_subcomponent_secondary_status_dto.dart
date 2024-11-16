class UpdateSubcomponentSecondaryStatusDto {
  final int sortOrder;

  UpdateSubcomponentSecondaryStatusDto({
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'sortOrder': sortOrder,
    };
  }
}
