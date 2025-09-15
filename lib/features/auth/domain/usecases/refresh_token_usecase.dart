import 'package:test/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.refreshToken();
  }
}
