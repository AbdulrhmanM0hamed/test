import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/domain/entities/product.dart';
import 'package:test/features/categories/domain/repositories/products_repository.dart';

class GetProductsByDepartmentUseCase {
  final ProductsRepository repository;

  const GetProductsByDepartmentUseCase(this.repository);

  Future<ApiResponse<ProductsResponse>> call(
    String departmentName, {
    int page = 1,
  }) async {
    return await repository.getProductsByDepartment(
      departmentName,
      page: page,
    );
  }
}
