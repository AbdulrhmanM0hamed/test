import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  const GetProfileUseCase(this.repository);

  Future<UserProfile> call() async {
    return await repository.getMyProfile();
  }
}
