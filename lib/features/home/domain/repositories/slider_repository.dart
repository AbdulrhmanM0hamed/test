import 'package:test/core/models/api_response.dart';
import 'package:test/features/home/domain/entities/slider.dart';

abstract class SliderRepository {
  Future<ApiResponse<List<Slider>>> getSliders();
}
