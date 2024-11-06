class RoleResponseDto {
  final int id;
  final String name;

  RoleResponseDto({
    required this.id,
    required this.name,
  });

  factory RoleResponseDto.fromJson(Map<String, dynamic> json) {
    return RoleResponseDto(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
