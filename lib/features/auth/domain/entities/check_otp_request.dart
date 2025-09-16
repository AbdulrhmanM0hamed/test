class CheckOtpRequest {
  final String email;
  final String otp;

  const CheckOtpRequest({
    required this.email,
    required this.otp,
  });
}
