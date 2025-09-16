class ChangePasswordRequest {
  final String email;
  final String otp;
  final String password;
  final String confirmPassword;

  const ChangePasswordRequest({
    required this.email,
    required this.otp,
    required this.password,
    required this.confirmPassword,
  });
}
