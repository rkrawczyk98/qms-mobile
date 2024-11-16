class SubcomponentSecondaryStatusResponseDto {
  final int id;
  final String name;
  final bool isCountedForShipping;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  SubcomponentSecondaryStatusResponseDto({
    required this.id,
    required this.name,
    required this.isCountedForShipping,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory SubcomponentSecondaryStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return SubcomponentSecondaryStatusResponseDto(
      id: json['id'],
      name: json['name'],
      isCountedForShipping: json['isCountedForShipping'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isCountedForShipping': isCountedForShipping,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
