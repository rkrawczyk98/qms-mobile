class CustomerResponseDto {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime lastModified;
  final List<dynamic>? deliveries;

  CustomerResponseDto({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.lastModified,
    this.deliveries,
  });

  factory CustomerResponseDto.fromJson(Map<String, dynamic> json) {
    return CustomerResponseDto(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deliveries: json['deliveries'] ?? [],
    );
  }
}
