class StatusDto {
  final int? id;
  final String? name;
  final int? sortOrder;

  StatusDto({this.id, this.name, this.sortOrder});

  factory StatusDto.fromJson(Map<String, dynamic> json) {
    return StatusDto(
      id: json['id'],
      name: json['name'],
      sortOrder: json['sortOrder'],
    );
  }
}

class SubcomponentConfigResponseDto {
  final int subcomponentId;
  final String subcomponentName;
  final List<StatusDto> primaryStatuses;
  final StatusDto secondaryStatus;
  final bool isIss;
  final bool isActivity;

  SubcomponentConfigResponseDto({
    required this.subcomponentId,
    required this.subcomponentName,
    required this.primaryStatuses,
    required this.secondaryStatus,
    required this.isIss,
    required this.isActivity,
  });

  factory SubcomponentConfigResponseDto.fromJson(Map<String, dynamic> json) {
    return SubcomponentConfigResponseDto(
      subcomponentId: json['subcomponentId'],
      subcomponentName: json['subcomponentName'],
      primaryStatuses: (json['primaryStatuses'] as List)
          .map((e) => StatusDto.fromJson(e))
          .toList(),
      secondaryStatus: StatusDto.fromJson(json['secondaryStatus']),
      isIss: json['isIss'],
      isActivity: json['isActivity'],
    );
  }
}
