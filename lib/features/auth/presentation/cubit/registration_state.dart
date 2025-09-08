import 'package:test/features/auth/domain/entities/user.dart';
import 'package:test/features/profile/domain/entities/country.dart';
import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/region.dart';

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final User user;
  RegistrationSuccess({required this.user});
}

class RegistrationError extends RegistrationState {
  final String message;
  RegistrationError({required this.message});
}

// Location states
class LocationLoading extends RegistrationState {}

class CountriesLoaded extends RegistrationState {
  final List<Country> countries;
  CountriesLoaded({required this.countries});
}

class CitiesLoaded extends RegistrationState {
  final List<City> cities;
  CitiesLoaded({required this.cities});
}

class RegionsLoaded extends RegistrationState {
  final List<Region> regions;
  RegionsLoaded({required this.regions});
}

class LocationError extends RegistrationState {
  final String message;
  LocationError({required this.message});
}
