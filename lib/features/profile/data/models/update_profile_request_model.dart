import 'package:dio/dio.dart';
import 'package:test/features/profile/domain/entities/update_profile_request.dart';

class UpdateProfileRequestModel extends UpdateProfileRequest {
  const UpdateProfileRequestModel({
    super.name,
    super.oldPassword,
    super.newPassword,
    super.confirmPassword,
    super.primaryImage,
    super.birthDate,
    super.phone,
    super.address,
    super.gender,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    // Only send supported fields according to the API endpoint
    if (name != null) {
      formData.fields.add(MapEntry('name', name!));
    }
    
    if (oldPassword != null) {
      formData.fields.add(MapEntry('old_password', oldPassword!));
    }
    
    if (newPassword != null) {
      formData.fields.add(MapEntry('new_password', newPassword!));
    }
    
    if (confirmPassword != null) {
      formData.fields.add(MapEntry('confirm_password', confirmPassword!));
    }
    
    if (birthDate != null) {
      formData.fields.add(MapEntry('birth_date', birthDate!));
    }
    
    if (phone != null) {
      formData.fields.add(MapEntry('phone', phone!));
    }

    if (primaryImage != null) {
      formData.files.add(
        MapEntry(
          'primary_image',
          await MultipartFile.fromFile(
            primaryImage!.path,
            filename: primaryImage!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
