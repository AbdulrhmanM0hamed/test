import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';

abstract class ProfileRepository {
  Future<UserProfile> getMyProfile();
  Future<UserProfile> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
    String? address,
    String? gender,
  });
  Future<UserProfile> updateProfileFromRequest(UpdateProfileRequest request);
  Future<void> updateProfileImage(String imagePath);
}
