class LoginRequest {
  final String email;
  final String password;
  final String? fcmToken;

  const LoginRequest({
    required this.email,
    required this.password,
    this.fcmToken,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequest &&
        other.email == email &&
        other.password == password &&
        other.fcmToken == fcmToken;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ fcmToken.hashCode;

  @override
  String toString() {
    return 'LoginRequest(email: $email, password: [HIDDEN])';
  }
}
