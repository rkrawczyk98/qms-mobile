class AddSubcomponentPrimaryStatusDto {
  final int statusId;
  final int sortOrder;

  AddSubcomponentPrimaryStatusDto({
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
