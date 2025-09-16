import 'package:test/core/models/api_response.dart';
import 'package:test/features/auth/domain/entities/check_otp_request.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';

class CheckOtpUseCase {
  final AuthRepository repository;

  CheckOtpUseCase({required this.repository});

  Future<ApiResponse<void>> call(CheckOtpRequest request) async {
    return await repository.checkOtp(request);
  }
}
