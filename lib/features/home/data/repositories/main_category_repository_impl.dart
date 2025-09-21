import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/network_info.dart';
import 'package:test/features/home/data/datasources/main_category_remote_data_source.dart';
import 'package:test/features/home/domain/entities/main_category.dart';
import 'package:test/features/home/domain/repositories/main_category_repository.dart';

class MainCategoryRepositoryImpl implements MainCategoryRepository {
  final MainCategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MainCategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<ApiResponse<List<MainCategory>>> getMainCategories() async {
    if (await networkInfo.isConnected) {
      final response = await remoteDataSource.getMainCategories();
      if (response.success) {
        return ApiResponse.success(
          data: response.data,
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
