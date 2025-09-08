import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getMyProfile();
  Future<UserProfileModel> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
    String? address,
    String? gender,
  });
  Future<void> updateProfileImage(String imagePath);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioService dioService;

  const ProfileRemoteDataSourceImpl(this.dioService);

  @override
  Future<UserProfileModel> getMyProfile() async {
    final response = await dioService.get(ApiEndpoints.myAccount);
    
    if (response.statusCode == 200) {
      final data = response.data['data'];
      return UserProfileModel.fromJson(data);
    } else {
      throw Exception('Failed to get profile: ${response.statusMessage}');
    }
  }

  @override
  Future<UserProfileModel> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
    String? address,
    String? gender,
  }) async {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (birthDate != null) data['birth_date'] = birthDate;
    if (address != null) data['address'] = address;
    if (gender != null) data['gender'] = gender;

    final response = await dioService.put(
      ApiEndpoints.myAccount,
      data: data,
    );
    
    if (response.statusCode == 200) {
      final responseData = response.data['data'];
      return UserProfileModel.fromJson(responseData);
    } else {
      throw Exception('Failed to update profile: ${response.statusMessage}');
    }
  }

  @override
  Future<void> updateProfileImage(String imagePath) async {
    // TODO: Implement form data creation for image upload
    // For now, we'll use a simple post request
    final response = await dioService.post(
      '${ApiEndpoints.myAccount}/update-image',
      data: {'image': imagePath},
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile image: ${response.statusMessage}');
    }
  }
}
