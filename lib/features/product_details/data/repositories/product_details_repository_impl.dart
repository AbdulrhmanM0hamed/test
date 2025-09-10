import 'package:test/core/models/api_response.dart';
import '../../domain/entities/product_details.dart';
import '../../domain/repositories/product_details_repository.dart';
import '../datasources/product_details_remote_data_source.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource _remoteDataSource;

  ProductDetailsRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<ProductDetails>> getProductDetails(int productId) async {
    try {
      final response = await _remoteDataSource.getProductDetails(productId);
      return response;
    } catch (e) {
      return ApiResponse.error(
        message: 'Repository error: ${e.toString()}',
      );
    }
  }
}
