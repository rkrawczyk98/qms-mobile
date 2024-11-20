class SecondaryStatusDto {
  final int statusId;
  final int sortOrder;

  SecondaryStatusDto({
    required this.statusId,
    required this.sortOrder,
  });

  factory SecondaryStatusDto.fromJson(Map<String, dynamic> json) {
    return SecondaryStatusDto(
      statusId: json['statusId'],
      sortOrder: json['sortOrder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusId': statusId,
      'sortOrder': sortOrder,
    };
  }
}
