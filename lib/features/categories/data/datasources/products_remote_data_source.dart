import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/categories/data/models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<ApiResponse<ProductsResponseModel>> getProductsByDepartment(
    String departmentName, {
    int page = 1,
  });
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final DioService dioService;

  const ProductsRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<ProductsResponseModel>> getProductsByDepartment(
    String departmentName, {
    int page = 1,
  }) async {
    try {
      final response = await dioService.get(
        ApiEndpoints.productsByDepartment(departmentName),
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final productsResponse = ProductsResponseModel.fromJson(response.data);
        return ApiResponse.success(
          data: productsResponse,
          message: response.data['message'] ?? 'Products loaded successfully',
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Failed to load products',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
