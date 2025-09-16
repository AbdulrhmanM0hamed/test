import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/domain/entities/user.dart';
import 'package:test/features/auth/domain/entities/login_request.dart';
import 'package:test/features/auth/domain/entities/forget_password_request.dart';
import 'package:test/features/auth/domain/entities/check_otp_request.dart';
import 'package:test/features/auth/domain/entities/change_password_request.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';
import 'package:test/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:test/features/auth/data/models/login_request_model.dart';
import 'package:test/features/auth/data/models/forget_password_request_model.dart';
import 'package:test/features/auth/data/models/check_otp_request_model.dart';
import 'package:test/features/auth/data/models/change_password_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResponse<User>> login(LoginRequest loginRequest) async {
    final loginRequestModel = LoginRequestModel.fromEntity(loginRequest);
    return await remoteDataSource.login(loginRequestModel);
  }

  @override
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
  }) async {
    return await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      birthDate: birthDate,
      gender: gender,
      countryId: countryId,
      cityId: cityId,
      regionId: regionId,
    );
  }

  @override
  Future<ApiResponse<void>> logout() async {
    return await remoteDataSource.logout();
  }

  @override
  Future<void> resetPassword(String email) async {
    return await remoteDataSource.resetPassword(email);
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    return await remoteDataSource.refreshToken();
  }

  @override
  Future<Map<String, dynamic>> resendVerificationEmail(String email) async {
    return await remoteDataSource.resendVerificationEmail(email);
  }

  @override
  Future<ApiResponse<void>> forgetPassword(ForgetPasswordRequest request) async {
    final requestModel = ForgetPasswordRequestModel.fromEntity(request);
    return await remoteDataSource.forgetPassword(requestModel);
  }

  @override
  Future<ApiResponse<void>> checkOtp(CheckOtpRequest request) async {
    final requestModel = CheckOtpRequestModel.fromEntity(request);
    return await remoteDataSource.checkOtp(requestModel);
  }

  @override
  Future<ApiResponse<void>> changePassword(ChangePasswordRequest request) async {
    final requestModel = ChangePasswordRequestModel.fromEntity(request);
    return await remoteDataSource.changePassword(requestModel);
  }
}
