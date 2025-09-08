import 'package:test/features/auth/domain/repositories/location_repository.dart';
import 'package:test/features/profile/domain/entities/region.dart';

class GetRegionsUseCase {
  final LocationRepository repository;

  GetRegionsUseCase({required this.repository});

  Future<List<Region>> call(int cityId) async {
    return await repository.getRegions(cityId);
  }
}
