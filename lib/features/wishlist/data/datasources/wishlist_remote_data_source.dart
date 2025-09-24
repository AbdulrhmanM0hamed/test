import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import '../models/wishlist_item_model.dart';

abstract class WishlistRemoteDataSource {
  Future<WishlistResponseModel> getMyWishlist();
  Future<Map<String, dynamic>> addToWishlist(int productId);
  Future<Map<String, dynamic>> removeFromWishlist(int productId);
  Future<Map<String, dynamic>> removeAllFromWishlist();
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final DioService _dioService;

  WishlistRemoteDataSourceImpl(this._dioService);

  @override
  Future<WishlistResponseModel> getMyWishlist() async {
    try {
      final response = await _dioService.get(ApiEndpoints.getWishlist);

      if (response.data is Map<String, dynamic>) {
        return WishlistResponseModel.fromJson(response.data);
      }

      return const WishlistResponseModel(count: 0, wishlist: []);
    } catch (e) {
      return const WishlistResponseModel(count: 0, wishlist: []);
    }
  }

  @override
  Future<Map<String, dynamic>> addToWishlist(int productId) async {
    final requestData = {
      'items': [
        {'product_id': productId},
      ],
    };

    final response = await _dioService.post(
      ApiEndpoints.addToWishlist,
      data: requestData,
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
  Future<Map<String, dynamic>> removeAllFromWishlist() async {
    try {
      //print('🗑️ WishlistRemoteDataSource: Starting removeAllFromWishlist');
      //print('🌐 API Endpoint: ${ApiEndpoints.removeAllFromWishlist}');

      final response = await _dioService.delete(
        ApiEndpoints.removeAllFromWishlist,
      );

      //print('✅ WishlistRemoteDataSource: removeAllFromWishlist success');
      //print('📊 Response status: ${response.statusCode}');
      //print('📋 Response data: ${response.data}');

      return response.data;
    } catch (e) {
      //print('❌ WishlistRemoteDataSource: removeAllFromWishlist failed');
      //print('🔥 Error: $e');
      //print('📍 Error type: ${e.runtimeType}');
      rethrow;
    }
  }
}
