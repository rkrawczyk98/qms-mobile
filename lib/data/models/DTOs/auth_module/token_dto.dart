class TokenDto {
  final String accessToken;

  TokenDto({required this.accessToken});

  factory TokenDto.fromJson(Map<String, dynamic> json) {
    return TokenDto(accessToken: json['access_token']);
  }
}
