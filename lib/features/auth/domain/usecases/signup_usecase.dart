import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/domain/entities/signup_request.dart';
import 'package:test/features/auth/domain/entities/user.dart';
import 'package:test/features/auth/domain/repositories/registration_repository.dart';

class SignupUseCase {
  final RegistrationRepository repository;

  SignupUseCase({required this.repository});

  Future<ApiResponse<User>> call(SignupRequest signupRequest) async {
    return await repository.signup(signupRequest);
  }
}
