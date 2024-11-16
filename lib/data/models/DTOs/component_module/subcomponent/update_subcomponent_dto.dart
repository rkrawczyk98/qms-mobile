class UpdateSubcomponentDto {
  final String? name;
  final int? componentTypeId;
  final int? sortOrder;
  final bool? isISS;
  final bool? isActivity;

  UpdateSubcomponentDto({
    this.name,
    this.componentTypeId,
    this.sortOrder,
    this.isISS,
    this.isActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (componentTypeId != null) 'componentTypeId': componentTypeId,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (isISS != null) 'isISS': isISS,
      if (isActivity != null) 'isActivity': isActivity,
    };
  }
}
