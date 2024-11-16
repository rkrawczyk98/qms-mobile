class ComponentSubcomponentResponseDto {
  final int id;
  final int componentId;
  final int subcomponentId;
  final int statusId;
  final int modifiedByUserId;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  ComponentSubcomponentResponseDto({
    required this.id,
    required this.componentId,
    required this.subcomponentId,
    required this.statusId,
    required this.modifiedByUserId,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory ComponentSubcomponentResponseDto.fromJson(Map<String, dynamic> json) {
    return ComponentSubcomponentResponseDto(
      id: json['id'],
      componentId: json['componentId'],
      subcomponentId: json['subcomponentId'],
      statusId: json['statusId'],
      modifiedByUserId: json['modifiedByUserId'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'componentId': componentId,
      'subcomponentId': subcomponentId,
      'statusId': statusId,
      'modifiedByUserId': modifiedByUserId,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
    };
  }
}
