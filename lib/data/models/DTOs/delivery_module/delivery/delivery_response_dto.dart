class DeliveryResponseDto {
  final int id;
  final String number;
  final CreatedByUserResponseDto? createdByUser;
  final ComponentTypeResponseDto? componentType;
  final DeliveryStatusResponseDto? status;
  final CustomerResponseDto? customer;
  final DateTime creationDate;
  final DateTime deliveryDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  DeliveryResponseDto({
    required this.id,
    required this.number,
    this.createdByUser,
    this.componentType,
    this.status,
    this.customer,
    required this.creationDate,
    required this.deliveryDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory DeliveryResponseDto.fromJson(Map<String, dynamic> json) {
    return DeliveryResponseDto(
      id: json['id'],
      number: json['number'],
      createdByUser: json['createdByUser'] != null
          ? CreatedByUserResponseDto.fromJson(json['createdByUser'])
          : null,
      componentType: json['componentType'] != null
          ? ComponentTypeResponseDto.fromJson(json['componentType'])
          : null,
      status: json['status'] != null
          ? DeliveryStatusResponseDto.fromJson(json['status'])
          : null,
      customer: json['customer'] != null
          ? CustomerResponseDto.fromJson(json['customer'])
          : null,
      creationDate: DateTime.parse(json['creationDate']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }
}

class CreatedByUserResponseDto {
  final int id;
  final String username;

  CreatedByUserResponseDto({required this.id, required this.username});

  factory CreatedByUserResponseDto.fromJson(Map<String, dynamic> json) {
    return CreatedByUserResponseDto(
      id: json['id'],
      username: json['username'],
    );
  }
}

class ComponentTypeResponseDto {
  final int id;
  final String name;

  ComponentTypeResponseDto({required this.id, required this.name});

  factory ComponentTypeResponseDto.fromJson(Map<String, dynamic> json) {
    return ComponentTypeResponseDto(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DeliveryStatusResponseDto {
  final int id;
  final String name;

  DeliveryStatusResponseDto({required this.id, required this.name});

  factory DeliveryStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return DeliveryStatusResponseDto(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CustomerResponseDto {
  final int id;
  final String name;

  CustomerResponseDto({required this.id, required this.name});

  factory CustomerResponseDto.fromJson(Map<String, dynamic> json) {
    return CustomerResponseDto(
      id: json['id'],
      name: json['name'],
    );
  }
}
