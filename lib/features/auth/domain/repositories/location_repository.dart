import 'package:test/features/profile/domain/entities/country.dart';
import 'package:test/features/profile/domain/entities/city.dart';
import 'package:test/features/profile/domain/entities/region.dart';

abstract class LocationRepository {
  Future<List<Country>> getCountries();
  Future<List<City>> getCities(int countryId);
  Future<List<Region>> getRegions(int cityId);
}
