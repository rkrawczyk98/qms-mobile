class CreateComponentSubcomponentDto {
  final int componentId;
  final int subcomponentId;
  final int statusId;
  final int modifiedByUserId;

  CreateComponentSubcomponentDto({
    required this.componentId,
    required this.subcomponentId,
    required this.statusId,
    required this.modifiedByUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'componentId': componentId,
      'subcomponentId': subcomponentId,
      'statusId': statusId,
      'modifiedByUserId': modifiedByUserId,
    };
  }
}
