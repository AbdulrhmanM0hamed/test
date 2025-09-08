import 'package:test/features/auth/domain/repositories/location_repository.dart';
import 'package:test/features/profile/domain/entities/city.dart';

class GetCitiesUseCase {
  final LocationRepository repository;

  GetCitiesUseCase({required this.repository});

  Future<List<City>> call(int countryId) async {
    return await repository.getCities(countryId);
  }
}
