import 'package:test/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getMyProfile();
  Future<UserProfile> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
    String? address,
    String? gender,
  });
  Future<void> updateProfileImage(String imagePath);
}
