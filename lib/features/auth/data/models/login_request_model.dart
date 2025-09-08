import 'package:test/features/auth/domain/entities/login_request.dart';

class LoginRequestModel extends LoginRequest {
  const LoginRequestModel({
    required super.email,
    required super.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginRequestModel.fromEntity(LoginRequest loginRequest) {
    return LoginRequestModel(
      email: loginRequest.email,
      password: loginRequest.password,
    );
  }
}
