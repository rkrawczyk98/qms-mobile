class CreateSubcomponentDto {
  final String name;
  final int componentTypeId;
  final int sortOrder;
  final bool isActivity;

  CreateSubcomponentDto({
    required this.name,
    required this.componentTypeId,
    required this.sortOrder,
    required this.isActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'componentTypeId': componentTypeId,
      'sortOrder': sortOrder,
      'isActivity': isActivity,
    };
  }
}
