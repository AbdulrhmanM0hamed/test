import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/network_info.dart';
import 'package:test/features/home/data/datasources/slider_remote_data_source.dart';
import 'package:test/features/home/domain/entities/slider.dart';
import 'package:test/features/home/domain/repositories/slider_repository.dart';

class SliderRepositoryImpl implements SliderRepository {
  final SliderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SliderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<ApiResponse<List<Slider>>> getSliders() async {
    if (await networkInfo.isConnected) {
      final response = await remoteDataSource.getSliders();
      if (response.success) {
        return ApiResponse.success(
          data: response.data?.map((slider) => slider.toEntity()).toList(),
          message: response.message,
        );
      } else {
        return ApiResponse.error(message: response.message);
      }
    } else {
      return ApiResponse.error(message: 'No internet connection');
    }
  }
}
