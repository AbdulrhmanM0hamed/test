import 'package:test/features/auth/domain/entities/login_request.dart';

class LoginRequestModel extends LoginRequest {
  const LoginRequestModel({
    required super.email,
    required super.password,
    super.fcmToken,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    
    if (fcmToken != null) {
      data['fcm_token'] = fcmToken;
    }
    
    return data;
  }

  factory LoginRequestModel.fromEntity(LoginRequest loginRequest) {
    return LoginRequestModel(
      email: loginRequest.email,
      password: loginRequest.password,
      fcmToken: loginRequest.fcmToken,
    );
  }
}
