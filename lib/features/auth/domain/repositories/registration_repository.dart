import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/domain/entities/signup_request.dart';
import 'package:test/features/auth/domain/entities/user.dart';

abstract class RegistrationRepository {
  Future<ApiResponse<User>> signup(SignupRequest signupRequest);
}
