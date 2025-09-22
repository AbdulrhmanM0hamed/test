import 'package:dio/dio.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/services/network/dio_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<ApiResponse<String>> checkout(OrderModel order);
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
}
