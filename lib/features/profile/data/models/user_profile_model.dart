import 'package:test/features/profile/domain/entities/user_profile.dart';
import 'package:test/features/profile/data/models/city_model.dart';
import 'package:test/features/profile/data/models/country_model.dart';
import 'package:test/features/profile/data/models/region_model.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
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
    required super.countryName,
    required super.city,
    required super.region,
    required super.country,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
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
      countryName: json['counrty'] ?? '', // Note: API has typo "counrty"
      city: CityModel.fromJson(json['city']),
      region: RegionModel.fromJson(json['region']),
      country: CountryModel.fromJson(json['country']),
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
      'counrty': countryName,
      'city': (city as CityModel).toJson(),
      'region': (region as RegionModel).toJson(),
      'country': (country as CountryModel).toJson(),
    };
  }
}
