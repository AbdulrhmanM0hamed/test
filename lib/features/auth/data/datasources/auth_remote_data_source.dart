import 'package:dio/dio.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/models/login_request_model.dart';
import 'package:test/features/auth/data/models/forget_password_request_model.dart';
import 'package:test/features/auth/data/models/check_otp_request_model.dart';
import 'package:test/features/auth/data/models/change_password_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<UserModel>> login(LoginRequestModel loginRequest);
  Future<UserModel> register({
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
  Future<ApiResponse<void>> forgetPassword(ForgetPasswordRequestModel request);
  Future<ApiResponse<void>> checkOtp(CheckOtpRequestModel request);
  Future<ApiResponse<void>> changePassword(ChangePasswordRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioService dioService;

  AuthRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<UserModel>> login(LoginRequestModel loginRequest) async {
    return await dioService.postWithResponse<UserModel>(
      ApiEndpoints.login,
      data: loginRequest.toJson(),
      dataParser: (data) => UserModel.fromJson(data),
    );
  }

  @override
  Future<UserModel> register({
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
    try {
      final response = await dioService.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'birth_date': birthDate,
          'gender': gender,
          'country_id': countryId,
          'city_id': cityId,
          'region_id': regionId,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> logout() async {
    final response = await dioService.postWithResponse<void>(
      ApiEndpoints.logout,
    );
    return response;
  }

  @override
  Future<ApiResponse<void>> resetPassword(String email) async {
    final response = await dioService.postWithResponse<void>(
      '${ApiEndpoints.baseUrl}reset-password',
      data: {'email': email},
    );
    return response;
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final response = await dioService.post(
        ApiEndpoints.refreshToken,
      );

      if (response.statusCode == 200 && response.data['status'] == 200) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: response.data['message'] ?? 'Token refresh failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> resendVerificationEmail(String email) async {
    try {
      final response = await dioService.post(
        ApiEndpoints.resendVerifyEmail,
        data: {'email': email},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> forgetPassword(ForgetPasswordRequestModel request) async {
    return await dioService.postWithResponse<void>(
      ApiEndpoints.forgetPassword,
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<void>> checkOtp(CheckOtpRequestModel request) async {
    return await dioService.postWithResponse<void>(
      ApiEndpoints.checkOtp,
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<void>> changePassword(ChangePasswordRequestModel request) async {
    return await dioService.postWithResponse<void>(
      ApiEndpoints.changePassword,
      data: request.toJson(),
    );
  }
}
