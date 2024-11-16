class UpdateSubcomponentStatusDto {
  final String? name;

  UpdateSubcomponentStatusDto({this.name});

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
    };
  }
}
