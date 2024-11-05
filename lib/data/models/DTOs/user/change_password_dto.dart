class ChangePasswordDto {
  final String currentPassword;
  final String newPassword;

  ChangePasswordDto({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}
