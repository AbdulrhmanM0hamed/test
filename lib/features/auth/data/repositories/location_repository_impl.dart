import 'package:test/features/auth/data/datasources/location_remote_data_source.dart';
import 'package:test/features/auth/domain/repositories/location_repository.dart';
import 'package:test/features/profile/domain/entities/country.dart';
import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/region.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Country>> getCountries() async {
    try {
      return await remoteDataSource.getCountries();
    } catch (e) {
      throw Exception('Failed to get countries: $e');
    }
  }

  @override
  Future<List<City>> getCities(int countryId) async {
    try {
      return await remoteDataSource.getCities(countryId);
    } catch (e) {
      throw Exception('Failed to get cities: $e');
    }
  }

  @override
  Future<List<Region>> getRegions(int cityId) async {
    try {
      return await remoteDataSource.getRegions(cityId);
    } catch (e) {
      throw Exception('Failed to get regions: $e');
    }
  }
}
