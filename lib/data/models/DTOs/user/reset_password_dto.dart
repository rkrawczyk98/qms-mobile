class ResetPasswordDto {
  final int userId;
  final String newPassword;

  ResetPasswordDto({
    required this.userId,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'newPassword': newPassword,
    };
  }
}
