class CreateComponentPrefixDto {
  final String prefix;
  final int componentTypeId;

  CreateComponentPrefixDto({
    required this.prefix,
    required this.componentTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'componentTypeId': componentTypeId,
    };
  }
}
