import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/domain/entities/forget_password_request.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';

class ForgetPasswordUseCase {
  final AuthRepository repository;

  ForgetPasswordUseCase({required this.repository});

  Future<ApiResponse<void>> call(ForgetPasswordRequest request) async {
    return await repository.forgetPassword(request);
  }
}
