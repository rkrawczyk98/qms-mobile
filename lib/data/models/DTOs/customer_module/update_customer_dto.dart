class UpdateCustomerDto {
  final String? name;

  UpdateCustomerDto({this.name});

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
