class _UserDto {
  final int id;
  final String username;

  _UserDto({
    required this.id,
    required this.username,
  });

  factory _UserDto.fromJson(Map<String, dynamic> json) {
    return _UserDto(
      id: json['id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }
}
class _ComponentSubcomponentResponseDto {
  final int id;
  final _UserDto modifiedByUser;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  _ComponentSubcomponentResponseDto({
    required this.id,
    required this.modifiedByUser,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory _ComponentSubcomponentResponseDto.fromJson(Map<String, dynamic> json) {
    return _ComponentSubcomponentResponseDto(
      id: json['id'],
      modifiedByUser: _UserDto.fromJson(json['modifiedByUser']),
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modifiedByUser': modifiedByUser.toJson(),
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}

class _Warehouse {
  final int id;
  final String name;

  _Warehouse({required this.id, required this.name});

  factory _Warehouse.fromJson(Map<String, dynamic> json) {
    return _Warehouse(
      id: json['id'],
      name: json['name'],
    );
  }
}

class _WarehousePosition {
  final int id;
  final String name;

  _WarehousePosition({required this.id, required this.name});

  factory _WarehousePosition.fromJson(Map<String, dynamic> json) {
    return _WarehousePosition(
      id: json['id'],
      name: json['name'],
    );
  }
}

class _Delivery {
  final int id;
  final String number;
  final DateTime? deliveryDate;

  _Delivery({required this.id, required this.number, required this.deliveryDate});

  factory _Delivery.fromJson(Map<String, dynamic> json) {
    return _Delivery(
      id: json['id'],
      number: json['number'],
      deliveryDate: DateTime.parse(json['deliveryDate'])
    );
  }
}

class _ComponentStatus {
  final int id;
  final String name;

  _ComponentStatus({required this.id, required this.name});

  factory _ComponentStatus.fromJson(Map<String, dynamic> json) {
    return _ComponentStatus(
      id: json['id'],
      name: json['name'],
    );
  }
}

class _ComponentType {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime? lastModified;
  final DateTime? deletedAt;
  final int? sortOrder;

  _ComponentType({required this.id, required this.name, required this.creationDate, required this.lastModified, required this.deletedAt, required this.sortOrder});

  factory _ComponentType.fromJson(Map<String, dynamic> json) {
    return _ComponentType(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      sortOrder: json['sortOrder'],
    );
  }
}

class ComponentResponseDto {
  final int id;
  final String nameOne;
  final String? nameTwo;
  final String insideNumber;
  final String? outsideNumber;
  final _UserDto createdByUser;
  final _UserDto modifiedByUser;
  final _ComponentType componentType;
  final _ComponentStatus status;
  final _Delivery delivery;
  final _Warehouse? warehouse;
  final _WarehousePosition? warehousePosition;
  final DateTime? scrappedAt;
  final DateTime? shippingDate;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;
  final double? size;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final String? wzNumber;
  final List<_ComponentSubcomponentResponseDto> componentSubcomponents;

  ComponentResponseDto({
    required this.id,
    required this.nameOne,
    this.nameTwo,
    required this.insideNumber,
    required this.outsideNumber,
    required this.createdByUser,
    required this.modifiedByUser,
    required this.componentType,
    required this.status,
    required this.delivery,
    this.warehouse,
    this.warehousePosition,
    this.scrappedAt,
    this.shippingDate,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
    this.size,
    this.controlDate,
    this.productionDate,
    this.wzNumber,
    required this.componentSubcomponents,
  });

  factory ComponentResponseDto.fromJson(Map<String, dynamic> json) {
    return ComponentResponseDto(
      id: json['id'],
      nameOne: json['nameOne'],
      nameTwo: json['nameTwo'],
      insideNumber: json['insideNumber'],
      outsideNumber: json['outsideNumber'],
      createdByUser: _UserDto.fromJson(json['createdByUser']),
      modifiedByUser: _UserDto.fromJson(json['modifiedByUser']),
      componentType: _ComponentType.fromJson(json['componentType']),
      status: _ComponentStatus.fromJson(json['status']),
      delivery: _Delivery.fromJson(json['delivery']),
      warehouse: _Warehouse.fromJson(json['warehouse']),
      warehousePosition: _WarehousePosition.fromJson(json['warehousePosition']),
      scrappedAt: json['scrappedAt'] != null
          ? DateTime.parse(json['scrappedAt'])
          : null,
      shippingDate: json['shippingDate'] != null
          ? DateTime.parse(json['shippingDate'])
          : null,
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      size: double.tryParse(json['size'].toString()),
      controlDate: json['controlDate'] != null
          ? DateTime.parse(json['controlDate'])
          : null,
      productionDate: json['productionDate'] != null
          ? DateTime.parse(json['productionDate'])
          : null,
      wzNumber: json['wzNumber'],
      componentSubcomponents: (json['componentSubcomponents'] as List<dynamic>)
          .map((e) => _ComponentSubcomponentResponseDto.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameOne': nameOne,
      'nameTwo': nameTwo,
      'insideNumber': insideNumber,
      'outsideNumber': outsideNumber,
      'createdByUser': createdByUser.toJson(),
      'modifiedByUser': modifiedByUser.toJson(),
      'componentType': componentType,
      'status': status,
      'delivery': delivery,
      'warehouse': warehouse,
      'warehousePosition': warehousePosition,
      'scrappedAt': scrappedAt?.toIso8601String(),
      'shippingDate': shippingDate?.toIso8601String(),
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'size': size,
      'controlDate': controlDate?.toIso8601String(),
      'productionDate': productionDate?.toIso8601String(),
      'wzNumber': wzNumber,
      'componentSubcomponents':
          componentSubcomponents.map((e) => e.toJson()).toList(),
    };
  }
}
