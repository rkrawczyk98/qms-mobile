class Permission {
  final int id;
  final String name;
  final DateTime creationDate;
  final DateTime lastModified;

  Permission({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.lastModified,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      name: json['name'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
    };
  }
}
