import '../repositories/auth_repository.dart';

class ResendVerificationEmailUseCase {
  final AuthRepository repository;

  ResendVerificationEmailUseCase(this.repository);

  Future<Map<String, dynamic>> call(String email) async {
    return await repository.resendVerificationEmail(email);
  }
}
