class UserInfo {
  final int id;
  final String username;
  final List<String> roles;
  final List<String> permissions;

  UserInfo({
    required this.id,
    required this.username,
    required this.roles,
    required this.permissions,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      username: json['username'],
      roles: List<String>.from(json['roles'].map((role) => role['name'])),
      permissions:
          List<String>.from(json['permissions'].map((perm) => perm['name'])),
    );
  }
}
