import 'package:test/core/models/api_response.dart';
import '../entities/product_details.dart';

abstract class ProductDetailsRepository {
  Future<ApiResponse<ProductDetails>> getProductDetails(int productId);
}
