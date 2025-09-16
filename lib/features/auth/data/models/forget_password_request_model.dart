import 'package:test/features/auth/domain/entities/forget_password_request.dart';

class ForgetPasswordRequestModel extends ForgetPasswordRequest {
  const ForgetPasswordRequestModel({
    required super.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  factory ForgetPasswordRequestModel.fromEntity(ForgetPasswordRequest entity) {
    return ForgetPasswordRequestModel(
      email: entity.email,
    );
  }
}
