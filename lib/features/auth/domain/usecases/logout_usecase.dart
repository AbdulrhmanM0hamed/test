import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  Future<ApiResponse<void>> call() async {
    return await repository.logout();
  }
}
