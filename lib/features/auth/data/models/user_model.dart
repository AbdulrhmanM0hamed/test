import 'package:test/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.image,
    super.birthDate,
    super.address,
    required super.gender,
    required super.status,
    super.emailVerifiedAt,
    required super.createdAt,
    required super.updatedAt,
    required super.countryId,
    required super.cityId,
    required super.regionId,
    required super.token,
    required super.expiresIn,
    required super.countryName,
    required super.cityName,
    required super.regionName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      birthDate: json['birth_date'],
      address: json['address'],
      gender: json['gender'],
      status: json['status'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      countryId: json['country_id'],
      cityId: json['city_id'],
      regionId: json['region_id'],
      token: json['token'],
      expiresIn: json['expires_in'],
      countryName: json['country_name'],
      cityName: json['city_name'],
      regionName: json['region_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'birth_date': birthDate,
      'address': address,
      'gender': gender,
      'status': status,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'country_id': countryId,
      'city_id': cityId,
      'region_id': regionId,
      'token': token,
      'expires_in': expiresIn,
      'country_name': countryName,
      'city_name': cityName,
      'region_name': regionName,
    };
  }
}