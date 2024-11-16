class SubcomponentStatusResponseDto {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  SubcomponentStatusResponseDto({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory SubcomponentStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return SubcomponentStatusResponseDto(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
