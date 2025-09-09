import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/data/datasources/products_remote_data_source.dart';
import 'package:test/features/categories/domain/entities/product.dart';
import 'package:test/features/categories/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  const ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResponse<ProductsResponse>> getProductsByDepartment(
    String departmentName, {
    int page = 1,
  }) async {
    try {
      final response = await remoteDataSource.getProductsByDepartment(
        departmentName,
        page: page,
      );

      if (response.success) {
        return ApiResponse.success(
          data: response.data!,
          message: response.message,
        );
      } else {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Repository error: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
