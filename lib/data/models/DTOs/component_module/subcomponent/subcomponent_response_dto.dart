class SubcomponentResponseDto {
  final int id;
  final String name;
  final int componentTypeId;
  final int sortOrder;
  final bool isISS;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;
  final bool isActivity;

  SubcomponentResponseDto({
    required this.id,
    required this.name,
    required this.componentTypeId,
    required this.sortOrder,
    required this.isISS,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
    required this.isActivity,
  });

  factory SubcomponentResponseDto.fromJson(Map<String, dynamic> json) {
    return SubcomponentResponseDto(
      id: json['id'],
      name: json['name'],
      componentTypeId: json['componentTypeId'],
      sortOrder: json['sortOrder'],
      isISS: json['isISS'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      isActivity: json['isActivity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'componentTypeId': componentTypeId,
      'sortOrder': sortOrder,
      'isISS': isISS,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'isActivity': isActivity,
    };
  }
}
