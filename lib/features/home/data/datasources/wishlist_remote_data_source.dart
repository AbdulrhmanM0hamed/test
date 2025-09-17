import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';

abstract class WishlistRemoteDataSource {
  Future<Map<String, dynamic>> addToWishlist(int productId);
  Future<Map<String, dynamic>> removeFromWishlist(int productId);
  Future<Map<String, dynamic>> getWishlist();
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final DioService _dioService;

  WishlistRemoteDataSourceImpl(this._dioService);

  @override
  Future<Map<String, dynamic>> addToWishlist(int productId) async {
    final response = await _dioService.post(
      ApiEndpoints.addToWishlist,
      data: {
        'items': [
          {'product_id': productId},
        ],
      },
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> removeFromWishlist(int productId) async {
    final response = await _dioService.delete(
      ApiEndpoints.removeFromWishlist(productId),
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getWishlist() async {
    final response = await _dioService.get(ApiEndpoints.getWishlist);
    return response.data;
  }
}
