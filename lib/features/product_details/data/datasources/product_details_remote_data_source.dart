import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import '../models/product_details_model.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<ApiResponse<ProductDetailsModel>> getProductDetails(int productId);
}

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final DioService _dioService;

  ProductDetailsRemoteDataSourceImpl(this._dioService);

  @override
  Future<ApiResponse<ProductDetailsModel>> getProductDetails(
    int productId,
  ) async {
    try {
      print(
        '🔍 ProductDetailsRemoteDataSource: Fetching product details for ID: $productId',
      );
      final response = await _dioService.get(
        ApiEndpoints.productDetails(productId),
      );

      print(
        '🔍 ProductDetailsRemoteDataSource: Response status: ${response.statusCode}',
      );
      print(
        '🔍 ProductDetailsRemoteDataSource: Response data keys: ${response.data?.keys}',
      );

      if (response.statusCode == 200) {
        print('🔍 ProductDetailsRemoteDataSource: Parsing product details...');
        print(
          '🔍 ProductDetailsRemoteDataSource: Raw data: ${response.data['data']}',
        );
        try {
          final productDetails = ProductDetailsModel.fromJson(
            response.data['data'],
          );
          print(
            '🔍 ProductDetailsRemoteDataSource: Successfully parsed product: ${productDetails.name}',
          );
          return ApiResponse.success(
            data: productDetails,
            message:
                response.data['message'] ??
                'Product details retrieved successfully',
          );
        } catch (e, stackTrace) {
          print('🔍 ProductDetailsRemoteDataSource: Detailed error: $e');
          print('🔍 ProductDetailsRemoteDataSource: Stack trace: $stackTrace');
          print(
            '🔍 ProductDetailsRemoteDataSource: Raw JSON keys: ${response.data['data']?.keys}',
          );

          // Print each field value and type for debugging
          final data = response.data['data'];
          if (data != null) {
            data.forEach((key, value) {
              print(
                '🔍 Field "$key": value="$value", type=${value.runtimeType}',
              );
            });
          }

          return ApiResponse.error(
            message: 'Failed to parse product details: $e',
          );
        }
      } else {
        print(
          '🔍 ProductDetailsRemoteDataSource: Error - Status code: ${response.statusCode}',
        );
        return ApiResponse.error(
          message: response.data['message'] ?? 'Failed to get product details',
        );
      }
    } catch (e) {
      print('🔍 ProductDetailsRemoteDataSource: Exception caught: $e');
      print(
        '🔍 ProductDetailsRemoteDataSource: Exception type: ${e.runtimeType}',
      );
      return ApiResponse.error(message: 'Network error: ${e.toString()}');
    }
  }
}
