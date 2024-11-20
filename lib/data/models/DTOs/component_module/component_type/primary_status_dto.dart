class PrimaryStatusDto {
  final int statusId;
  final int sortOrder;

  PrimaryStatusDto({
    required this.statusId,
    required this.sortOrder,
  });

  factory PrimaryStatusDto.fromJson(Map<String, dynamic> json) {
    return PrimaryStatusDto(
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
