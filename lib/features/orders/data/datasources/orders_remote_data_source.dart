import 'package:dio/dio.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/services/network/dio_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/order_model.dart';
import '../models/my_orders_response.dart';
import '../models/order_details_response.dart';

abstract class OrdersRemoteDataSource {
  Future<ApiResponse<String>> checkout(OrderModel order);
  Future<ApiResponse<MyOrdersResponse>> getMyOrders();
  Future<ApiResponse<OrderDetailsResponse>> getOrderDetails(int orderId);
  Future<ApiResponse<Map<String, dynamic>>> cancelOrder(int orderId);
  Future<ApiResponse<Map<String, dynamic>>> returnOrder(int orderId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final DioService dioService;

  OrdersRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<String>> checkout(OrderModel order) async {
    try {
      final response = await dioService.postWithResponse(
        ApiEndpoints.checkout,
        data: order.toCheckoutJson(),
        dataParser: (data) => data['order_id'].toString(),
      );
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        return ApiResponse.error(
          message: e.response?.data?['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      return ApiResponse.error(message: 'Unexpected error occurred');
    }
  }

  @override
  Future<ApiResponse<MyOrdersResponse>> getMyOrders() async {
    try {
      print('🔍 Starting getMyOrders...');
      final response = await dioService.get(ApiEndpoints.myOrders);
      print('🔍 Raw response: ${response.data}');

      final myOrdersResponse = MyOrdersResponse.fromJson(response.data);
      print('🔍 Parsed successfully!');

      return ApiResponse.success(data: myOrdersResponse, message: 'Success');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        return ApiResponse.error(
          message: e.response?.data?['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      print('❌ Unexpected error in getMyOrders: $e');
      return ApiResponse.error(message: 'Failed to parse server response: $e');
    }
  }

  @override
  Future<ApiResponse<OrderDetailsResponse>> getOrderDetails(int orderId) async {
    try {
      print('🔍 Starting getOrderDetails for order: $orderId');
      final response = await dioService.get(ApiEndpoints.orderDetails(orderId));
      print('🔍 Raw order details response: ${response.data}');

      final orderDetailsResponse = OrderDetailsResponse.fromJson(response.data);
      print('🔍 Order details parsed successfully!');

      return ApiResponse.success(
        data: orderDetailsResponse,
        message: 'Success',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        return ApiResponse.error(
          message: e.response?.data?['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      print('❌ Unexpected error in getOrderDetails: $e');
      return ApiResponse.error(message: 'Failed to parse order details: $e');
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> cancelOrder(int orderId) async {
    try {
      print('🔍 Starting cancelOrder for order: $orderId');
      final response = await dioService.put(ApiEndpoints.cancelOrder(orderId));
      print('🔍 Cancel order response: ${response.data}');

      return ApiResponse.success(
        data: response.data as Map<String, dynamic>,
        message: response.data['message'] ?? 'Order cancelled successfully',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        return ApiResponse.error(
          message: e.response?.data?['message'] ?? 'Failed to cancel order',
        );
      }
    } catch (e) {
      print('❌ Unexpected error in cancelOrder: $e');
      return ApiResponse.error(message: 'Failed to cancel order: $e');
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> returnOrder(int orderId) async {
    try {
      print('🔍 Starting returnOrder for order: $orderId');
      final response = await dioService.put(ApiEndpoints.returnOrder(orderId));
      print('🔍 Return order response: ${response.data}');

      return ApiResponse.success(
        data: response.data as Map<String, dynamic>,
        message: response.data['message'] ?? 'Order return requested successfully',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        return ApiResponse.error(
          message: e.response?.data?['message'] ?? 'Failed to request order return',
        );
      }
    } catch (e) {
      print('❌ Unexpected error in returnOrder: $e');
      return ApiResponse.error(message: 'Failed to request order return: $e');
    }
  }
}
