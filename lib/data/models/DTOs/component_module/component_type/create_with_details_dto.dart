import 'subcomponent_details_dto.dart';

class CreateWithDetailsDto {
  final String name;
  final int sortOrder;
  final String prefix;
  final List<SubcomponentDetailsDto> subcomponents;

  CreateWithDetailsDto({
    required this.name,
    required this.sortOrder,
    required this.prefix,
    required this.subcomponents,
  });

  factory CreateWithDetailsDto.fromJson(Map<String, dynamic> json) {
    return CreateWithDetailsDto(
      name: json['componentType']['name'],
      sortOrder: json['componentType']['sortOrder'],
      prefix: json['prefix']['prefix'],
      subcomponents: (json['subcomponents'] as List)
          .map((e) => SubcomponentDetailsDto.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'componentType': {
        'name': name,
        'sortOrder': sortOrder,
      },
      'prefix': {
        'prefix': prefix,
      },
      'subcomponents': subcomponents.map((e) => e.toJson()).toList(),
    };
  }
}
