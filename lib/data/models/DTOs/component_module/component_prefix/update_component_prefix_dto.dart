class UpdateComponentPrefixDto {
  final String? prefix;
  final int? componentTypeId;

  UpdateComponentPrefixDto({
    this.prefix,
    this.componentTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (prefix != null) 'prefix': prefix,
      if (componentTypeId != null) 'componentTypeId': componentTypeId,
    };
  }
}
