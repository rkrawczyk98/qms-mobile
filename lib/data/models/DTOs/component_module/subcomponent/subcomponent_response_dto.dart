class SubcomponentResponseDto {
  final int id;
  final String name;
  final int componentTypeId;
  final int sortOrder;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;
  final bool isActivity;

  SubcomponentResponseDto({
    required this.id,
    required this.name,
    required this.componentTypeId,
    required this.sortOrder,
    required this.creationDate,
    required this.lastModified,
    required this.deletedAt,
    required this.isActivity,
  });

  factory SubcomponentResponseDto.fromJson(Map<String, dynamic> json) {
    return SubcomponentResponseDto(
      id: json['id'],
      name: json['name'],
      componentTypeId: json['componentTypeId'],
      sortOrder: json['sortOrder'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      isActivity: json['isActivity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'componentTypeId': componentTypeId,
      'sortOrder': sortOrder,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'isActivity': isActivity,
    };
  }

  SubcomponentResponseDto copyWith({
    int? id,
    String? name,
    int? componentTypeId,
    int? sortOrder,
    DateTime? creationDate,
    DateTime? lastModified,
    DateTime? deletedAt,
    bool? isActivity,
  }) {
    return SubcomponentResponseDto(
      id: id ?? this.id,
      name: name ?? this.name,
      componentTypeId: componentTypeId ?? this.componentTypeId,
      sortOrder: sortOrder ?? this.sortOrder,
      creationDate: creationDate ?? this.creationDate,
      lastModified: lastModified ?? this.lastModified,
      isActivity: isActivity ?? this.isActivity,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
