class ComponentPrefixResponseDto {
  final int id;
  final String prefix;
  final int componentTypeId;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  ComponentPrefixResponseDto({
    required this.id,
    required this.prefix,
    required this.componentTypeId,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory ComponentPrefixResponseDto.fromJson(Map<String, dynamic> json) {
    return ComponentPrefixResponseDto(
      id: json['id'],
      prefix: json['prefix'],
      componentTypeId: json['componentTypeId'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prefix': prefix,
      'componentTypeId': componentTypeId,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
    };
  }
}
