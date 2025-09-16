import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/domain/entities/user.dart';
import 'package:test/features/auth/domain/entities/login_request.dart';
import 'package:test/features/auth/domain/entities/forget_password_request.dart';
import 'package:test/features/auth/domain/entities/check_otp_request.dart';
import 'package:test/features/auth/domain/entities/change_password_request.dart';

abstract class AuthRepository {
  Future<ApiResponse<User>> login(LoginRequest loginRequest);
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String birthDate,
    required String gender,
    required int countryId,
    required int cityId,
    required int regionId,
  });
  Future<ApiResponse<void>> logout();
  Future<void> resetPassword(String email);
  Future<Map<String, dynamic>> refreshToken();
  Future<Map<String, dynamic>> resendVerificationEmail(String email);
  Future<ApiResponse<void>> forgetPassword(ForgetPasswordRequest request);
  Future<ApiResponse<void>> checkOtp(CheckOtpRequest request);
  Future<ApiResponse<void>> changePassword(ChangePasswordRequest request);
}
