class UpdateComponentStatusDto {
  final String? name;
  final bool? isCountedForShipping;

  UpdateComponentStatusDto({
    this.name,
    this.isCountedForShipping,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (isCountedForShipping != null) 'isCountedForShipping': isCountedForShipping,
    };
  }
}
