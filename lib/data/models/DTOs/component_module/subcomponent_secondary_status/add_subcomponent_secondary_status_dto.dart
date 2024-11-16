class AddSubcomponentSecondaryStatusDto {
  final int statusId;
  final int sortOrder;

  AddSubcomponentSecondaryStatusDto({
    required this.statusId,
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'statusId': statusId,
      'sortOrder': sortOrder,
    };
  }
}
