import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/country.dart';
import 'package:test/features/profile/domain/entities/region.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationCountriesLoading extends LocationState {}

class LocationCountriesLoaded extends LocationState {
  final List<Country> countries;

  LocationCountriesLoaded({required this.countries});
}

class LocationCitiesLoading extends LocationState {
  final List<Country> countries;

  LocationCitiesLoading({required this.countries});
}

class LocationCitiesLoaded extends LocationState {
  final List<Country> countries;
  final List<City> cities;

  LocationCitiesLoaded({required this.countries, required this.cities});
}

class LocationRegionsLoading extends LocationState {
  final List<Country> countries;
  final List<City> cities;

  LocationRegionsLoading({required this.countries, required this.cities});
}

class LocationRegionsLoaded extends LocationState {
  final List<Country> countries;
  final List<City> cities;
  final List<Region> regions;

  LocationRegionsLoaded({
    required this.countries,
    required this.cities,
    required this.regions,
  });
}

class LocationError extends LocationState {
  final String message;

  LocationError({required this.message});
}
