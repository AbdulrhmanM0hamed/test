import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:test/core/models/api_response.dart';
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

  /// Handle server response and create structured ApiResponse
  static ApiResponse<T> handleResponse<T>(
    Response response, {
    T Function(dynamic)? dataParser,
  }) {
    try {
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if response indicates success
        final bool isSuccess =
            response.statusCode == 200 || response.statusCode == 201;

        if (isSuccess) {
          T? parsedData;
          if (responseData['data'] != null && dataParser != null) {
            // Handle empty array case for successful operations
            if (responseData['data'] is List &&
                (responseData['data'] as List).isEmpty) {
              // For empty data array, still try to parse with dataParser
              parsedData = dataParser(responseData['data']);
            } else if (responseData['data'] is Map ||
                responseData['data'] is List) {
              parsedData = dataParser(responseData['data']);
            }
          }

          return ApiResponse.success(
            message:
                responseData['message'] ?? 'Operation completed successfully',
            data: parsedData,
            statusCode: response.statusCode,
          );
        } else {
          return ApiResponse.error(
            message: responseData['message'] ?? 'Operation failed',
            errors: responseData['errors'] as Map<String, dynamic>?,
            statusCode: response.statusCode,
          );
        }
      } else {
        // Handle non-JSON responses
        return ApiResponse.success(
          message: 'Operation completed successfully',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to parse server response',
        statusCode: response.statusCode,
      );
    }
  }

  /// Handle DioException and create structured ApiException
  static ApiException handleDioException(DioException error) {
    String message = 'حدث خطأ غير متوقع';
    Map<String, dynamic>? errors;
    int? statusCode = error.response?.statusCode;

    if (error.response?.data != null && error.response!.data is Map) {
      final responseData = error.response!.data as Map<String, dynamic>;
      message = responseData['message'] ?? message;
      errors = responseData['errors'] as Map<String, dynamic>?;
    } else {
      // Handle network and other errors
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';
          break;
        case DioExceptionType.badResponse:
          switch (statusCode) {
            case 404:
              message = 'الخدمة غير موجودة';
              break;
            case 422:
              message = 'البيانات المدخلة غير صحيحة';
              break;
            case 500:
              message = 'خطأ في الخادم. يرجى المحاولة لاحقاً.';
              break;
            default:
              message = 'حدث خطأ في الخادم';
          }
          break;
        case DioExceptionType.connectionError:
          message = 'لا يوجد اتصال بالإنترنت';
          break;
        case DioExceptionType.cancel:
          message = 'تم إلغاء العملية';
          break;
        default:
          message = 'حدث خطأ غير متوقع';
      }
    }

    return ApiException(
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  /// Enhanced POST method with structured response handling
  Future<ApiResponse<T>> postWithResponse<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? dataParser,
  }) async {
    try {
      final response = await post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return handleResponse<T>(response, dataParser: dataParser);
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  /// Enhanced GET method with structured response handling
  Future<ApiResponse<T>> getWithResponse<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? dataParser,
  }) async {
    try {
      final response = await get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return handleResponse<T>(response, dataParser: dataParser);
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  /// Enhanced PUT method with structured response handling
  Future<ApiResponse<T>> putWithResponse<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? dataParser,
  }) async {
    try {
      final response = await put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return handleResponse<T>(response, dataParser: dataParser);
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  /// Enhanced DELETE method with structured response handling
  Future<ApiResponse<T>> deleteWithResponse<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? dataParser,
  }) async {
    try {
      final response = await delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return handleResponse<T>(response, dataParser: dataParser);
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }
}
