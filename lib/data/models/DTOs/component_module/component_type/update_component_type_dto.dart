class UpdateComponentTypeDto {
  final String? name;
  final int? sortOrder;

  UpdateComponentTypeDto({
    this.name,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (sortOrder != null) 'sortOrder': sortOrder,
    };
  }
}
