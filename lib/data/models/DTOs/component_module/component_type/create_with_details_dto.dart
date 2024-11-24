import 'subcomponent_details_dto.dart';

class CreateWithDetailsDto {
  final String name;
  final String prefix;
  final List<SubcomponentDetailsDto> subcomponents;

  CreateWithDetailsDto({
    required this.name,
    required this.prefix,
    required this.subcomponents,
  });

  factory CreateWithDetailsDto.fromJson(Map<String, dynamic> json) {
    return CreateWithDetailsDto(
      name: json['componentType']['name'],
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
      },
      'prefix': {
        'prefix': prefix,
      },
      'subcomponents': subcomponents.map((e) => e.toJson()).toList(),
    };
  }
}
