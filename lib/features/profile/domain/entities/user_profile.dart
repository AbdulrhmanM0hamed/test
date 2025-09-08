import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/country.dart';
import 'package:test/features/profile/domain/entities/region.dart';

class UserProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final String? birthDate;
  final String? address;
  final String gender;
  final String status;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final int countryId;
  final int cityId;
  final int regionId;
  final String countryName;
  final City city;
  final Region region;
  final Country country;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    this.birthDate,
    this.address,
    required this.gender,
    required this.status,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.countryId,
    required this.cityId,
    required this.regionId,
    required this.countryName,
    required this.city,
    required this.region,
    required this.country,
  });

  bool get isEmailVerified => emailVerifiedAt != null;
  bool get isActive => status == "1";
  String get displayName => name.isNotEmpty ? name : email.split('@').first;
  String get fullLocation => '${region.titleAr}, ${city.titleAr}, ${country.titleAr}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() => 'UserProfile(id: $id, name: $name, email: $email)';
}
