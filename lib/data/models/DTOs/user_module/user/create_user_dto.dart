class CreateUserDto {
  final String username;
  final String password;

  CreateUserDto({required this.username, required this.password});

  factory CreateUserDto.fromJson(Map<String, dynamic> json) {
    return CreateUserDto(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
