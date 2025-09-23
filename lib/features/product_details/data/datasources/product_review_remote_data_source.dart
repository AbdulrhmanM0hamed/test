import 'package:dio/dio.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/services/network/dio_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';

abstract class ProductReviewRemoteDataSource {
  Future<ApiResponse<String>> submitReview({
    required int productId,
    required String review,
    required int star,
  });
}

class ProductReviewRemoteDataSourceImpl implements ProductReviewRemoteDataSource {
  final DioService _dioService;

  ProductReviewRemoteDataSourceImpl(this._dioService);

  @override
  Future<ApiResponse<String>> submitReview({
    required int productId,
    required String review,
    required int star,
  }) async {
    final response = await _dioService.postWithResponse<String>(
      ApiEndpoints.productReview(productId),
      data: {
        'review': review,
        'star': star,
      },
      dataParser: (data) => data?.toString() ?? 'Review submitted successfully',
    );

    return response;
  }
}
