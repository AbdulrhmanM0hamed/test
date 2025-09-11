import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/auth/data/datasources/location_remote_data_source.dart';
import 'package:test/features/auth/presentation/cubit/location_state.dart';
import 'package:test/features/profile/domain/entities/country.dart';
import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/region.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRemoteDataSource locationRemoteDataSource;

  LocationCubit({required this.locationRemoteDataSource})
    : super(LocationInitial());

  Future<void> getCountries() async {
    try {
      emit(LocationCountriesLoading());
      final countries = await locationRemoteDataSource.getCountries();

      final countryEntities = countries.map((model) {
        return Country(
          id: model.id,
          image: model.image,
          titleEn: model.titleEn,
          titleAr: model.titleAr,
          currency: model.currency,
          currencyAr: model.currencyAr,
          shortcut: model.shortcut,
          code: model.code,
          status: model.status,
        );
      }).toList();

      emit(LocationCountriesLoaded(countries: countryEntities));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> getCities(int countryId) async {
    try {
      // Get current countries from state
      List<Country> currentCountries = [];
      if (state is LocationCountriesLoaded) {
        currentCountries = (state as LocationCountriesLoaded).countries;
      } else if (state is LocationCitiesLoaded) {
        currentCountries = (state as LocationCitiesLoaded).countries;
      } else if (state is LocationRegionsLoading) {
        currentCountries = (state as LocationRegionsLoading).countries;
      } else if (state is LocationRegionsLoaded) {
        currentCountries = (state as LocationRegionsLoaded).countries;
      }

      emit(LocationCitiesLoading(countries: currentCountries));
      final cities = await locationRemoteDataSource.getCities(countryId);

      final cityEntities = cities.map((model) {
        return City(
          id: model.id,
          image: model.image,
          titleEn: model.titleEn,
          titleAr: model.titleAr,
          code: model.code,
          status: model.status,
          countryId: model.countryId,
        );
      }).toList();

      emit(
        LocationCitiesLoaded(countries: currentCountries, cities: cityEntities),
      );
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> getRegions(int cityId) async {
    try {
      // Get current countries and cities from state
      List<Country> currentCountries = [];
      List<City> currentCities = [];
      if (state is LocationCitiesLoaded) {
        currentCountries = (state as LocationCitiesLoaded).countries;
        currentCities = (state as LocationCitiesLoaded).cities;
      } else if (state is LocationRegionsLoading) {
        currentCountries = (state as LocationRegionsLoading).countries;
        currentCities = (state as LocationRegionsLoading).cities;
      } else if (state is LocationRegionsLoaded) {
        currentCountries = (state as LocationRegionsLoaded).countries;
        currentCities = (state as LocationRegionsLoaded).cities;
      }

      emit(
        LocationRegionsLoading(
          countries: currentCountries,
          cities: currentCities,
        ),
      );
      final regions = await locationRemoteDataSource.getRegions(cityId);

      final regionEntities = regions.map((model) {
        return Region(
          id: model.id,
          titleEn: model.titleEn,
          titleAr: model.titleAr,
          code: model.code,
          status: model.status,
          cityId: model.cityId,
        );
      }).toList();

      emit(
        LocationRegionsLoaded(
          countries: currentCountries,
          cities: currentCities,
          regions: regionEntities,
        ),
      );
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }
}
