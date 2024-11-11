import 'package:qms_mobile/data/models/DTOs/user_module/role/role.dart';
import 'package:qms_mobile/data/models/DTOs/user_module/user/user_response_dto.dart';

class UserRoleResponseDto {
  final int id;
  final UserResponseDto user;
  final Role role;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  UserRoleResponseDto({
    required this.id,
    required this.user,
    required this.role,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory UserRoleResponseDto.fromJson(Map<String, dynamic> json) {
    return UserRoleResponseDto(
      id: json['id'] as int,
      user: UserResponseDto.fromJson(json['user']),
      role: Role.fromJson(json['role']),
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'role': role.toJson(),
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
