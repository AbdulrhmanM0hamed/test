import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/token_storage_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';

class DioService {
  static DioService? _instance;
  late Dio _dio;
  TokenStorageService? _tokenStorageService;
  AuthRepository? _authRepository;
  BuildContext? _context;
  bool _isRefreshing = false;

  DioService._internal() {
    _dio = Dio();
    _initializeDio();
  }

  void setTokenStorageService(TokenStorageService tokenStorageService) {
    _tokenStorageService = tokenStorageService;
  }

  void setAuthRepository(AuthRepository authRepository) {
    _authRepository = authRepository;
  }

  void setContext(BuildContext context) {
    _context = context;
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
          // Add authorization token
          final token = _tokenStorageService?.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          // Add language header based on app locale
          String language = 'ar'; // Default to Arabic
          if (_context != null) {
            final locale = Localizations.localeOf(_context!);
            language = locale.languageCode == 'en' ? 'en' : 'ar';
          }
          options.headers['lang'] = language;
          
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
        onError: (error, handler) async {
          if (kDebugMode) {
            print(
              '❌ ERROR: ${error.requestOptions.method} ${error.requestOptions.uri}',
            );
            print('💥 MESSAGE: ${error.message}');
            print('📊 STATUS: ${error.response?.statusCode}');
            print('📥 DATA: ${error.response?.data}');
          }

          // Handle token refresh for 401 errors
          if (error.response?.statusCode == 401 && 
              !_isRefreshing && 
              _tokenStorageService != null && 
              _authRepository != null &&
              error.requestOptions.path != ApiEndpoints.refreshToken) {
            
            _isRefreshing = true;
            
            try {
              // Check if token should be refreshed
              if (_tokenStorageService!.shouldRefreshToken || _tokenStorageService!.isTokenExpired) {
                print('🔄 Attempting to refresh token...');
                
                final refreshData = await _authRepository!.refreshToken();
                final newToken = refreshData['access_token'] as String;
                final expiresIn = refreshData['expires_in'] as int?;
                
                // Update token in storage
                await _tokenStorageService!.updateAccessToken(newToken, expiresIn: expiresIn);
                
                print('✅ Token refreshed successfully');
                
                // Retry the original request with new token
                final options = error.requestOptions;
                options.headers['Authorization'] = 'Bearer $newToken';
                
                final response = await _dio.fetch(options);
                _isRefreshing = false;
                handler.resolve(response);
                return;
              }
            } catch (refreshError) {
              print('❌ Token refresh failed: $refreshError');
              _isRefreshing = false;
              
              // Clear tokens and redirect to login
              await _tokenStorageService!.clearAll();
              
              // You might want to navigate to login screen here
              // This would require additional context handling
            }
            
            _isRefreshing = false;
          }
          
          handler.next(error);
        },
      ),
    );
  }

  // Internal method for making requests
  Future<Response> _makeRequest(
    String method,
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // Check if token needs refresh before making request
    if (_tokenStorageService != null && 
        _authRepository != null && 
        !_isRefreshing &&
        endpoint != ApiEndpoints.refreshToken &&
        _tokenStorageService!.shouldRefreshToken) {
      
      await _refreshTokenIfNeeded();
    }
    
    try {
      switch (method.toUpperCase()) {
        case 'GET':
          return await _dio.get(
            endpoint,
            queryParameters: queryParameters,
            options: options,
          );
        case 'POST':
          return await _dio.post(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
        case 'PUT':
          return await _dio.put(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
        case 'DELETE':
          return await _dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Handle server response and create structured ApiResponse
  ApiResponse<T> _handleResponse<T>(
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
  ApiException _handleDioException(DioException error) {
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

  /// Enhanced request method with structured response handling
  Future<ApiResponse<T>> requestWithResponse<T>(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? dataParser,
  }) async {
    try {
      final response = await _makeRequest(
        method,
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, dataParser: dataParser);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// POST method with structured response handling
  Future<ApiResponse<T>> postWithResponse<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? dataParser,
  }) async {
    return requestWithResponse<T>(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      dataParser: dataParser,
    );
  }

  /// GET method with structured response handling
  Future<ApiResponse<T>> getWithResponse<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? dataParser,
  }) async {
    return requestWithResponse<T>(
      'GET',
      path,
      queryParameters: queryParameters,
      options: options,
      dataParser: dataParser,
    );
  }

  /// PUT method with structured response handling
  Future<ApiResponse<T>> putWithResponse<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? dataParser,
  }) async {
    return requestWithResponse<T>(
      'PUT',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      dataParser: dataParser,
    );
  }

  /// DELETE method with structured response handling
  Future<ApiResponse<T>> deleteWithResponse<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? dataParser,
  }) async {
    return requestWithResponse<T>(
      'DELETE',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      dataParser: dataParser,
    );
  }

  // Legacy methods for backward compatibility
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _makeRequest(
      'GET',
      endpoint,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _makeRequest(
      'POST',
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _makeRequest(
      'PUT',
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _makeRequest(
      'DELETE',
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Helper method to refresh token if needed
  Future<void> _refreshTokenIfNeeded() async {
    if (_isRefreshing || _tokenStorageService == null || _authRepository == null) {
      return;
    }

    _isRefreshing = true;
    
    try {
      print('🔄 Proactively refreshing token...');
      
      final refreshData = await _authRepository!.refreshToken();
      final newToken = refreshData['access_token'] as String;
      final expiresIn = refreshData['expires_in'] as int?;
      
      // Update token in storage
      await _tokenStorageService!.updateAccessToken(newToken, expiresIn: expiresIn);
      
      print('✅ Token refreshed proactively');
    } catch (e) {
      print('❌ Proactive token refresh failed: $e');
      // Don't clear tokens here, let the 401 handler deal with it
    } finally {
      _isRefreshing = false;
    }
  }
}
