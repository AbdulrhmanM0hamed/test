import 'package:dio/dio.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/services/network/dio_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/promo_code_model.dart';

abstract class PromoCodeRemoteDataSource {
  Future<ApiResponse<PromoCodeModel>> checkPromoCode(String code);
}

class PromoCodeRemoteDataSourceImpl implements PromoCodeRemoteDataSource {
  final DioService dioService;

  PromoCodeRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<PromoCodeModel>> checkPromoCode(String code) async {
    try {
      final response = await dioService.postWithResponse(
        ApiEndpoints.checkPromo,
        data: {'code': code},
        dataParser: (data) => PromoCodeModel.fromJson(data),
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
        return ApiResponse.error(message: 'Server error occurred');
      }
    } catch (e) {
      return ApiResponse.error(message: 'Unknown error occurred');
    }
  }
}
