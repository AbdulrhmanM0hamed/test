import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/data/models/product_filter_model.dart';
import 'package:test/features/categories/data/models/product_model.dart';
import 'package:test/features/categories/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<ApiResponse<ProductsResponse>> getProductsByDepartment(
    String departmentName, {
    int page = 1,
  });
  
  Future<ApiResponse<ProductsResponseModel>> getAllProducts(
    ProductFilterModel filter,
  );
}
