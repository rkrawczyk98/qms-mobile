import 'primary_status_dto.dart';
import 'secondary_status_dto.dart';

class SubcomponentDetailsDto {
  final String name;
  final int sortOrder;
  final bool isActivity;
  final List<PrimaryStatusDto> primaryStatuses;
  final List<SecondaryStatusDto> secondaryStatuses;

  SubcomponentDetailsDto({
    required this.name,
    required this.sortOrder,
    required this.isActivity,
    required this.primaryStatuses,
    required this.secondaryStatuses,
  });

  factory SubcomponentDetailsDto.fromJson(Map<String, dynamic> json) {
    return SubcomponentDetailsDto(
      name: json['subcomponent']['name'],
      sortOrder: json['subcomponent']['sortOrder'],
      isActivity: json['subcomponent']['isActivity'],
      primaryStatuses: (json['primaryStatuses'] as List)
          .map((e) => PrimaryStatusDto.fromJson(e))
          .toList(),
      secondaryStatuses: (json['secondaryStatuses'] as List)
          .map((e) => SecondaryStatusDto.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subcomponent': {
        'name': name,
        'sortOrder': sortOrder,
        'isActivity': isActivity,
      },
      'primaryStatuses': primaryStatuses.map((e) => e.toJson()).toList(),
      'secondaryStatuses': secondaryStatuses.map((e) => e.toJson()).toList(),
    };
  }

  SubcomponentDetailsDto copyWith({
    String? name,
    int? sortOrder,
    bool? isActivity,
    List<PrimaryStatusDto>? primaryStatuses,
    List<SecondaryStatusDto>? secondaryStatuses,
  }) {
    return SubcomponentDetailsDto(
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActivity: isActivity ?? this.isActivity,
      primaryStatuses: primaryStatuses ?? this.primaryStatuses,
      secondaryStatuses: secondaryStatuses ?? this.secondaryStatuses,
    );
  }
}
