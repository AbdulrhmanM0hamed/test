import 'package:test/features/auth/domain/entities/check_otp_request.dart';

class CheckOtpRequestModel extends CheckOtpRequest {
  const CheckOtpRequestModel({
    required super.email,
    required super.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }

  factory CheckOtpRequestModel.fromEntity(CheckOtpRequest entity) {
    return CheckOtpRequestModel(
      email: entity.email,
      otp: entity.otp,
    );
  }
}
