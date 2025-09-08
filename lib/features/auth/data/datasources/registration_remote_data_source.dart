import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/auth/data/models/signup_request_model.dart';
import 'package:test/features/auth/data/models/user_model.dart';

abstract class RegistrationRemoteDataSource {
  Future<UserModel> signup(SignupRequestModel signupRequest);
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final DioService dioService;

  RegistrationRemoteDataSourceImpl({required this.dioService});

  @override
  Future<UserModel> signup(SignupRequestModel signupRequest) async {
    try {
      final response = await dioService.post(
        ApiEndpoints.register,
        data: signupRequest.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = response.data['data']['user'];
        return UserModel.fromJson(userData);
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }
}
