import 'dart:io';

class UpdateProfileRequest {
  final String? name;
  final String? oldPassword;
  final String? newPassword;
  final String? confirmPassword;
  final File? primaryImage;
  final String? birthDate;
  final String? phone;
  final String? address;
  final String? gender;

  const UpdateProfileRequest({
    this.name,
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
    this.primaryImage,
    this.birthDate,
    this.phone,
    this.address,
    this.gender,
  });

  bool get isEmpty =>
      name == null &&
      oldPassword == null &&
      newPassword == null &&
      confirmPassword == null &&
      primaryImage == null &&
      birthDate == null &&
      phone == null &&
      address == null &&
      gender == null;

  bool get hasPasswordChange =>
      oldPassword != null && newPassword != null && confirmPassword != null;
}
