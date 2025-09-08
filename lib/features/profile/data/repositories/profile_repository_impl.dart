import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/domain/repositories/profile_repository.dart';
import 'package:test/features/profile/data/datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserProfile> getMyProfile() async {
    return await remoteDataSource.getMyProfile();
  }

  @override
  Future<UserProfile> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
    String? address,
    String? gender,
  }) async {
    return await remoteDataSource.updateProfile(
      name: name,
      phone: phone,
      birthDate: birthDate,
      address: address,
      gender: gender,
    );
  }

  @override
  Future<void> updateProfileImage(String imagePath) async {
    return await remoteDataSource.updateProfileImage(imagePath);
  }
}
