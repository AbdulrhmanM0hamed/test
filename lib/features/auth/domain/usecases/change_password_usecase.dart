import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/domain/entities/change_password_request.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase({required this.repository});

  Future<ApiResponse<void>> call(ChangePasswordRequest request) async {
    return await repository.changePassword(request);
  }
}
