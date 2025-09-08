import 'package:test/features/auth/domain/entities/signup_request.dart';

class SignupRequestModel extends SignupRequest {
  const SignupRequestModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.birthDate,
    required super.gender,
    required super.signFrom,
    required super.password,
    required super.confirmPassword,
    required super.countryId,
    required super.cityId,
    required super.regionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'birth_date': birthDate,
      'gender': gender,
      'sign_from': signFrom,
      'password': password,
      'confirm_password': confirmPassword,
      'country_id': countryId.toString(),
      'city_id': cityId.toString(),
      'region_id': regionId.toString(),
    };
  }
}
