import 'package:dio/dio.dart';
import 'package:test/core/services/network/dio_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/cart_model.dart';
import '../../domain/entities/add_to_cart_request.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<String> addToCart(AddToCartRequest request);
  Future<String> removeFromCart(int cartItemId);
  Future<String> removeAllFromCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final DioService dioService;

  CartRemoteDataSourceImpl({required this.dioService});

  @override
  Future<CartModel> getCart() async {
    try {
      final response = await dioService.get(ApiEndpoints.getCart);
      
      if (response.statusCode == 200) {
        return CartModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<String> addToCart(AddToCartRequest request) async {
    try {
      final response = await dioService.post(
        ApiEndpoints.addToCart,
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'تم إضافة المنتج إلى السلة بنجاح';
      } else {
        throw Exception('Failed to add to cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<String> removeFromCart(int cartItemId) async {
    try {
      final response = await dioService.delete(
        ApiEndpoints.removeFromCart(cartItemId),
      );
      
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'تم حذف المنتج من السلة بنجاح';
      } else {
        throw Exception('Failed to remove from cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<String> removeAllFromCart() async {
    try {
      final response = await dioService.delete(
        ApiEndpoints.removeAllFromCart,
      );
      
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'تم حذف جميع المنتجات من السلة بنجاح';
      } else {
        throw Exception('Failed to clear cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
