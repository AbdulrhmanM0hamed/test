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
      print('🔄 LocationCubit: Starting to fetch countries...');
      emit(LocationCountriesLoading());
      final countries = await locationRemoteDataSource.getCountries();
      print(
        '✅ LocationCubit: Received ${countries.length} countries from data source',
      );

      final countryEntities = countries.map((model) {
        print('🏳️ Processing country: ${model.titleAr} (ID: ${model.id})');
        print('   Image: ${model.image}');
        print('   Currency: ${model.currency}');
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

      print(
        '✅ LocationCubit: Successfully created ${countryEntities.length} country entities',
      );
      emit(LocationCountriesLoaded(countries: countryEntities));
    } catch (e) {
      print('❌ LocationCubit: Error fetching countries: $e');
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> getCities(int countryId) async {
    try {
      print(
        '🔄 LocationCubit: Starting to fetch cities for country $countryId...',
      );

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
      print(
        '✅ LocationCubit: Received ${cities.length} cities from data source',
      );

      final cityEntities = cities.map((model) {
        print('🏙️ Processing city: ${model.titleAr} (ID: ${model.id})');
        print('   Image: ${model.image}');
        print('   Code: ${model.code}');
        print('   Status: ${model.status}');
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

      print(
        '✅ LocationCubit: Successfully created ${cityEntities.length} city entities',
      );
      emit(
        LocationCitiesLoaded(countries: currentCountries, cities: cityEntities),
      );
    } catch (e) {
      print('❌ LocationCubit: Error fetching cities: $e');
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> getRegions(int cityId) async {
    try {
      print('🔄 LocationCubit: Starting to fetch regions for city $cityId...');

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
      print(
        '✅ LocationCubit: Received ${regions.length} regions from data source',
      );

      final regionEntities = regions.map((model) {
        print('🏘️ Processing region: ${model.titleAr} (ID: ${model.id})');
        print('   Code: ${model.code}');
        print('   Status: ${model.status}');
        return Region(
          id: model.id,
          titleEn: model.titleEn,
          titleAr: model.titleAr,
          code: model.code,
          status: model.status,
          cityId: model.cityId,
        );
      }).toList();

      print(
        '✅ LocationCubit: Successfully created ${regionEntities.length} region entities',
      );
      emit(
        LocationRegionsLoaded(
          countries: currentCountries,
          cities: currentCities,
          regions: regionEntities,
        ),
      );
    } catch (e) {
      print('❌ LocationCubit: Error fetching regions: $e');
      emit(LocationError(message: e.toString()));
    }
  }
}
