import 'package:test/features/auth/domain/entities/change_password_request.dart';

class ChangePasswordRequestModel extends ChangePasswordRequest {
  const ChangePasswordRequestModel({
    required super.email,
    required super.otp,
    required super.password,
    required super.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'password': password,
      'password_confirmation': confirmPassword,
    };
  }

  factory ChangePasswordRequestModel.fromEntity(ChangePasswordRequest entity) {
    return ChangePasswordRequestModel(
      email: entity.email,
      otp: entity.otp,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
    );
  }
}
