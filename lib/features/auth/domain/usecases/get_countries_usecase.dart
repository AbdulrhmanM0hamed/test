import 'package:test/features/auth/domain/repositories/location_repository.dart';
import 'package:test/features/profile/domain/entities/country.dart';

class GetCountriesUseCase {
  final LocationRepository repository;

  GetCountriesUseCase({required this.repository});

  Future<List<Country>> call() async {
    return await repository.getCountries();
  }
}
