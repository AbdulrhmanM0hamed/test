import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/profile/data/models/city_model.dart';
import 'package:test/features/profile/data/models/country_model.dart';
import 'package:test/features/profile/data/models/region_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<CountryModel>> getCountries();
  Future<List<CityModel>> getCities(int countryId);
  Future<List<RegionModel>> getRegions(int cityId);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final DioService dioService;

  LocationRemoteDataSourceImpl({required this.dioService});

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      print('🌐 LocationRemoteDataSource: Calling API...');
      final response = await dioService.get(ApiEndpoints.countries);
      print(
        '📡 LocationRemoteDataSource: Response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        print(
          '📦 LocationRemoteDataSource: Received ${data.length} countries from API',
        );

        final countries = data.map((json) {
          print('🔍 Parsing country JSON: $json');
          try {
            final country = CountryModel.fromJson(json);
            print('✅ Successfully parsed: ${country.titleAr}');
            return country;
          } catch (e) {
            print('❌ Error parsing country: $e');
            rethrow;
          }
        }).toList();

        print(
          '✅ LocationRemoteDataSource: Successfully parsed ${countries.length} countries',
        );
        return countries;
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      print('❌ LocationRemoteDataSource: Error fetching countries: $e');
      throw Exception('Error fetching countries: $e');
    }
  }

  @override
  Future<List<CityModel>> getCities(int countryId) async {
    try {
      print(
        '🌐 LocationRemoteDataSource: Calling cities API for country $countryId...',
      );
      final response = await dioService.get(ApiEndpoints.cities(countryId));
      print(
        '📡 LocationRemoteDataSource: Cities response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        print(
          '📦 LocationRemoteDataSource: Received ${data.length} cities from API',
        );

        final cities = data.map((json) {
          print('🔍 Parsing city JSON: $json');
          try {
            final city = CityModel.fromJson(json);
            print('✅ Successfully parsed city: ${city.titleAr}');
            return city;
          } catch (e) {
            print('❌ Error parsing city: $e');
            rethrow;
          }
        }).toList();

        print(
          '✅ LocationRemoteDataSource: Successfully parsed ${cities.length} cities',
        );
        return cities;
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      print('❌ LocationRemoteDataSource: Error fetching cities: $e');
      throw Exception('Error fetching cities: $e');
    }
  }

  @override
  Future<List<RegionModel>> getRegions(int cityId) async {
    try {
      final response = await dioService.get(ApiEndpoints.regions(cityId));

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => RegionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load regions');
      }
    } catch (e) {
      throw Exception('Error fetching regions: $e');
    }
  }
}
