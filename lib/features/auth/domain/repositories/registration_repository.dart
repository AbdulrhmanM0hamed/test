import 'package:test/features/auth/domain/entities/signup_request.dart';
import 'package:test/features/auth/domain/entities/user.dart';

abstract class RegistrationRepository {
  Future<User> signup(SignupRequest signupRequest);
}
