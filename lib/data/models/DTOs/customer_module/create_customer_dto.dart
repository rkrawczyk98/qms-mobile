class CreateCustomerDto {
  final String name;

  CreateCustomerDto({required this.name});

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
