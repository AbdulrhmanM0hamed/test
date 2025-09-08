import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:test/core/services/token_storage_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';

class DioService {
  static DioService? _instance;
  late Dio _dio;
  TokenStorageService? _tokenStorageService;

  DioService._internal() {
    _dio = Dio();
    _initializeDio();
  }

  void setTokenStorageService(TokenStorageService tokenStorageService) {
    _tokenStorageService = tokenStorageService;
  }

  static DioService get instance {
    _instance ??= DioService._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenStorageService?.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            print('🚀 REQUEST: ${options.method} ${options.uri}');
            print('📤 DATA: ${options.data}');
            print('🔑 HEADERS: ${options.headers}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
            );
            print('📥 DATA: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print(
              '❌ ERROR: ${error.requestOptions.method} ${error.requestOptions.uri}',
            );
            print('💥 MESSAGE: ${error.message}');
            print('📊 STATUS: ${error.response?.statusCode}');
            print('📥 DATA: ${error.response?.data}');
          }
          handler.next(error);
        },
      ),
    );
  }

  // Generic GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Generic POST request
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Generic PUT request
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Generic DELETE request
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Handle API errors and extract meaningful messages
  static Map<String, dynamic> handleError(DioException error) {
    String messageEn = 'Something went wrong';
    String messageAr = 'حدث خطأ ما';

    if (error.response?.data != null && error.response!.data is Map) {
      final data = error.response!.data as Map<String, dynamic>;
      messageEn = data['message_en'] ?? messageEn;
      messageAr = data['message_ar'] ?? messageAr;
    } else {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          messageEn = 'Connection timeout. Please try again.';
          messageAr = 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';
          break;
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 404) {
            messageEn = 'Service not found';
            messageAr = 'الخدمة غير موجودة';
          } else if (error.response?.statusCode == 500) {
            messageEn = 'Server error. Please try again later.';
            messageAr = 'خطأ في الخادم. يرجى المحاولة لاحقاً.';
          }
          break;
        case DioExceptionType.connectionError:
          messageEn = 'No internet connection';
          messageAr = 'لا يوجد اتصال بالإنترنت';
          break;
        default:
          messageEn = 'Something went wrong';
          messageAr = 'حدث خطأ ما';
      }
    }

    return {'success': false, 'message_en': messageEn, 'message_ar': messageAr};
  }
}
