import 'package:test/core/models/api_response.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';
import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase({required this.repository});

  Future<UserProfile> call(UpdateProfileRequest request) async {
    print('DEBUG: UpdateProfileUseCase.call started');
    print('DEBUG: Request details - name: ${request.name}, phone: ${request.phone}');
    
    try {
      final result = await repository.updateProfileFromRequest(request);
      print('DEBUG: UpdateProfileUseCase.call completed successfully');
      print('DEBUG: Result name: ${result.name}');
      return result;
    } catch (e) {
      print('DEBUG: UpdateProfileUseCase.call failed with error: $e');
      rethrow;
    }
  }
}
