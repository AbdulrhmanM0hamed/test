import 'package:test/features/auth/domain/entities/user.dart';
import 'package:test/features/auth/domain/entities/login_request.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<User> call(LoginRequest loginRequest) async {
    return await repository.login(loginRequest);
  }
}
