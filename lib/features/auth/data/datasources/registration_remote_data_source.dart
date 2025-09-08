import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/auth/data/models/signup_request_model.dart';
import 'package:test/features/auth/data/models/user_model.dart';

abstract class RegistrationRemoteDataSource {
  Future<ApiResponse<UserModel>> signup(SignupRequestModel signupRequest);
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final DioService dioService;

  RegistrationRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<UserModel>> signup(SignupRequestModel signupRequest) async {
    return await dioService.postWithResponse<UserModel>(
      ApiEndpoints.register,
      data: signupRequest.toJson(),
      dataParser: (data) {
        // Handle case where server returns empty data array on successful registration
        if (data is List && data.isEmpty) {
          // Create minimal user object for successful registration
          return UserModel.fromJson({
            'id': 0, // Temporary ID since user needs email verification
            'name': signupRequest.name,
            'email': signupRequest.email,
            'phone': signupRequest.phone,
            'gender': 'unknown',
            'status': '1',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'country_id': 0,
            'city_id': 0,
            'region_id': 0,
            'token': '',
            'expires_in': 0,
            'country_name': '',
            'city_name': '',
            'region_name': '',
          });
        } else if (data is Map<String, dynamic>) {
          // Handle case where server returns user data
          return UserModel.fromJson(data);
        } else {
          // Fallback for successful registration
          return UserModel.fromJson({
            'id': 0,
            'name': signupRequest.name,
            'email': signupRequest.email,
            'phone': signupRequest.phone,
            'gender': 'unknown',
            'status': '1',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'country_id': 0,
            'city_id': 0,
            'region_id': 0,
            'token': '',
            'expires_in': 0,
            'country_name': '',
            'city_name': '',
            'region_name': '',
          });
        }
      },
    );
  }
}
