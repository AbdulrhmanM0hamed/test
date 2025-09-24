import 'package:dio/dio.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/profile/data/models/user_profile_model.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getMyProfile();
  Future<UserProfileModel> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
  });
  Future<UserProfileModel> updateProfileFromRequest(
    UpdateProfileRequest request,
  );
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

    final response = await dioService.put(ApiEndpoints.myAccount, data: data);

    if (response.statusCode == 200) {
      final responseData = response.data['data'];
      return UserProfileModel.fromJson(responseData);
    } else {
      throw Exception('Failed to update profile: ${response.statusMessage}');
    }
  }

  @override
  Future<void> updateProfileImage(String imagePath) async {
    //print('DEBUG: updateProfileImage called with path: $imagePath');

    // Create FormData for file upload
    final formData = FormData.fromMap({
      'primary_image': await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      ),
    });

    //print('DEBUG: FormData created, making POST request');

    final response = await dioService.post(
      ApiEndpoints.updateProfile,
      data: formData,
    );

    //print('DEBUG: Response status: ${response.statusCode}');
    //print('DEBUG: Response data: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update profile image: ${response.statusMessage}',
      );
    }
  }

  @override
  Future<UserProfileModel> updateProfileFromRequest(
    UpdateProfileRequest request,
  ) async {
    //print('DEBUG: ProfileRemoteDataSource.updateProfileFromRequest called');

    // Check if this is an image-only update
    if (request.primaryImage != null &&
        request.name == null &&
        request.phone == null &&
        request.birthDate == null &&
        request.oldPassword == null) {
      //print('DEBUG: Image-only update detected');

      // Create FormData for file upload
      final formData = FormData.fromMap({
        'primary_image': await MultipartFile.fromFile(
          request.primaryImage!.path,
          filename: request.primaryImage!.path.split('/').last,
        ),
      });

      //print('DEBUG: FormData created for image upload');

      final response = await dioService.post(
        ApiEndpoints.updateProfile,
        data: formData,
      );

      //print('DEBUG: Image upload response status: ${response.statusCode}');
      //print('DEBUG: Image upload response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data['data'];
        return UserProfileModel.fromJson(responseData);
      } else {
        throw Exception(
          'Failed to update profile image: ${response.statusMessage}',
        );
      }
    }

    // Regular update (non-image fields)
    final Map<String, dynamic> data = {};

    if (request.name != null) data['name'] = request.name;
    if (request.phone != null) data['phone'] = request.phone;
    if (request.birthDate != null) data['birth_date'] = request.birthDate;
    if (request.oldPassword != null) data['old_password'] = request.oldPassword;
    if (request.newPassword != null) data['new_password'] = request.newPassword;
    if (request.confirmPassword != null) {
      data['new_password_confirmation'] = request.confirmPassword;
    }

    //print('DEBUG: Request data: $data');
    //print('DEBUG: Making POST request to ${ApiEndpoints.updateProfile}');

    try {
      final response = await dioService.post(
        ApiEndpoints.updateProfile,
        data: data,
      );
      //print('DEBUG: Response status: ${response.statusCode}');
      //print('DEBUG: Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data['data'];
        //print('DEBUG: Parsing response data to UserProfileModel');
        return UserProfileModel.fromJson(responseData);
      } else {
        //print('DEBUG: Request failed with status: ${response.statusCode}');
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } catch (e) {
      //print('DEBUG: Exception in updateProfileFromRequest: $e');
      rethrow;
    }
  }
}
