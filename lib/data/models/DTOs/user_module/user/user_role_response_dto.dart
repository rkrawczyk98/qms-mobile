import 'role_response_dto.dart';
import 'user_response_dto.dart';

class UserRoleResponseDto {
  final UserResponseDto user;
  final List<RoleResponseDto?> roles;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;

  UserRoleResponseDto({
    required this.user,
    required this.roles,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
  });

  factory UserRoleResponseDto.fromJson(Map<String, dynamic> json) {
    return UserRoleResponseDto(
      user: UserResponseDto.fromJson(json['user']),
      roles: (json['roles'] as List?)
              ?.where((role) =>
                  role != null &&
                  role is Map<String, dynamic> &&
                  role.isNotEmpty)
              .map((role) => RoleResponseDto.fromJson(role))
              .toList() ??
          [],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'roles': roles.map((role) => role?.toJson()).toList(),
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
