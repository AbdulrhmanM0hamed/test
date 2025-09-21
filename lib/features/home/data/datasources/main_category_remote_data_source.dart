import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/home/data/models/main_category_model.dart';
import 'package:dio/dio.dart';

abstract class MainCategoryRemoteDataSource {
  Future<ApiResponse<List<MainCategoryModel>>> getMainCategories();
}

class MainCategoryRemoteDataSourceImpl implements MainCategoryRemoteDataSource {
  final DioService dioService;

  MainCategoryRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<List<MainCategoryModel>>> getMainCategories() async {
    try {
      final response = await dioService.getWithResponse(
        ApiEndpoints.mainCategories,
        dataParser: (data) {
          if (data is List) {
            return data
                .map((category) => MainCategoryModel.fromJson(category))
                .toList();
          }
          return <MainCategoryModel>[];
        },
      );
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        return ApiResponse.error(message: 'Server error occurred');
      }
    } catch (e) {
      return ApiResponse.error(message: 'Unknown error occurred');
    }
  }
}
