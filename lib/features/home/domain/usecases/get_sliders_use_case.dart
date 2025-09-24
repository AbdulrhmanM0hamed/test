import '../entities/slider.dart';
import '../repositories/slider_repository.dart';

class GetSlidersUseCase {
  final SliderRepository repository;

  GetSlidersUseCase({required this.repository});

  Future<List<Slider>> call() async {
    final response = await repository.getSliders();
    if (response.success) {
      return response.data ?? [];
    } else {
      throw Exception(response.message);
    }
  }
}
