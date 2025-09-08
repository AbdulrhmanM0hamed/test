class User {
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
  final String token;
  final int expiresIn;
  final String countryName;
  final String cityName;
  final String regionName;

  const User({
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
    required this.token,
    required this.expiresIn,
    required this.countryName,
    required this.cityName,
    required this.regionName,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.token == token;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ token.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}
