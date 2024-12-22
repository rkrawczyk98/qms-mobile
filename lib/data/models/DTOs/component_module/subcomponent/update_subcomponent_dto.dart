class UpdateSubcomponentDto {
  final String? name;
  final int? componentTypeId;
  final int? sortOrder;
  final bool? isActivity;
  final DateTime? deletedAt;

  UpdateSubcomponentDto({
    this.name,
    this.componentTypeId,
    this.sortOrder,
    this.isActivity,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (componentTypeId != null) 'componentTypeId': componentTypeId,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (isActivity != null) 'isActivity': isActivity,
      if (deletedAt != null)
        'deletedAt': deletedAt!.toIso8601String()
      else
        'deletedAt': null,
    };
  }

  UpdateSubcomponentDto copyWith({
    String? name,
    int? componentTypeId,
    int? sortOrder,
    bool? isActivity,
    DateTime? deletedAt,
  }) {
    return UpdateSubcomponentDto(
      name: name ?? this.name,
      componentTypeId: componentTypeId ?? this.componentTypeId,
      sortOrder: sortOrder ?? this.sortOrder,
      isActivity: isActivity ?? this.isActivity,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
