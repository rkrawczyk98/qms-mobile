class ComponentTypeResponseDto {
  final int id;
  final String name;
  final int sortOrder;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  ComponentTypeResponseDto({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory ComponentTypeResponseDto.fromJson(Map<String, dynamic> json) {
    return ComponentTypeResponseDto(
      id: json['id'],
      name: json['name'],
      sortOrder: json['sortOrder'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sortOrder': sortOrder,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
    };
  }

  ComponentTypeResponseDto copyWith({
    int? id,
    String? name,
    int? sortOrder,
    DateTime? creationDate,
    DateTime? lastModified,
    DateTime? deletedAt,
  }) {
    return ComponentTypeResponseDto(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      creationDate: creationDate ?? this.creationDate,
      lastModified: lastModified ?? this.lastModified,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
