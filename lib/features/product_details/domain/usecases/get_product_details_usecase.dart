import 'package:test/core/models/api_response.dart';
import '../entities/product_details.dart';
import '../repositories/product_details_repository.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepository _repository;

  GetProductDetailsUseCase(this._repository);

  Future<ApiResponse<ProductDetails>> call(int productId) async {
    return await _repository.getProductDetails(productId);
  }
}
