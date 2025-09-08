class SignupRequest {
  final String name;
  final String email;
  final String phone;
  final String birthDate;
  final String gender;
  final String signFrom;
  final String password;
  final String confirmPassword;
  final int countryId;
  final int cityId;
  final int regionId;

  const SignupRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.gender,
    required this.signFrom,
    required this.password,
    required this.confirmPassword,
    required this.countryId,
    required this.cityId,
    required this.regionId,
  });
}
