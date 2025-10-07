import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/token_storage_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/auth/domain/repositories/auth_repository.dart';
import 'package:test/l10n/app_localizations.dart';

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
      // Allow 4xx and 5xx status codes to be handled as responses instead of exceptions
      validateStatus: (status) {
        return status != null && status < 500;
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
              if (_tokenStorageService!.shouldRefreshToken ||
                  _tokenStorageService!.isTokenExpired) {
                print('🔄 Attempting to refresh token...');

                final refreshData = await _authRepository!.refreshToken();
                final newToken = refreshData['access_token'] as String;
                final expiresIn = refreshData['expires_in'] as int?;

                // Update token in storage
                await _tokenStorageService!.updateAccessToken(
                  newToken,
                  expiresIn: expiresIn,
                );

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
            response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300;

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
          // Handle 4xx client errors with detailed validation messages
          if (response.statusCode == 422 && responseData['data'] is Map) {
            final validationErrors =
                responseData['data'] as Map<String, dynamic>;
            final errorMessages = <String>[];

            // Extract field-specific error messages
            validationErrors.forEach((field, fieldErrors) {
              if (fieldErrors is List && fieldErrors.isNotEmpty) {
                errorMessages.addAll(fieldErrors.map((e) => e.toString()));
              } else if (fieldErrors is String) {
                errorMessages.add(fieldErrors);
              }
            });

            String finalMessage =
                responseData['message'] ?? 'Validation failed';
            if (errorMessages.isNotEmpty) {
              finalMessage = errorMessages.join('\n');
            }

            return ApiResponse.error(
              message: finalMessage,
              errors: validationErrors,
              statusCode: response.statusCode,
            );
          }

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

  /// Handle DioException and create structured ApiException with localized messages
  ApiException _handleDioException(DioException error) {
    String message;
    Map<String, dynamic>? errors;
    int? statusCode = error.response?.statusCode;

    // Get localized messages
    AppLocalizations? localizations;
    if (_context != null) {
      localizations = AppLocalizations.of(_context!);
    }

    // Check if server provided a custom message
    if (error.response?.data != null && error.response!.data is Map) {
      final responseData = error.response!.data as Map<String, dynamic>;

      // Extract server message
      String? serverMessage = responseData['message']?.toString();

      // For validation errors (422), try to extract detailed field errors
      if (statusCode == 422 && responseData['data'] is Map) {
        final validationErrors = responseData['data'] as Map<String, dynamic>;
        final errorMessages = <String>[];

        // Extract field-specific error messages
        validationErrors.forEach((field, fieldErrors) {
          if (fieldErrors is List && fieldErrors.isNotEmpty) {
            errorMessages.addAll(fieldErrors.map((e) => e.toString()));
          } else if (fieldErrors is String) {
            errorMessages.add(fieldErrors);
          }
        });

        // Combine server message with field errors
        if (errorMessages.isNotEmpty) {
          if (serverMessage != null && serverMessage.isNotEmpty) {
            message = '$serverMessage\n${errorMessages.join('\n')}';
          } else {
            message = errorMessages.join('\n');
          }
        } else if (serverMessage != null && serverMessage.isNotEmpty) {
          message = serverMessage;
        } else {
          message = _getStatusCodeMessage(statusCode, localizations);
        }

        errors = validationErrors;
        return ApiException(
          message: message,
          errors: errors,
          statusCode: statusCode,
        );
      }

      // For other errors, use server message if available
      if (serverMessage != null && serverMessage.isNotEmpty) {
        return ApiException(
          message: serverMessage,
          errors: responseData['errors'] as Map<String, dynamic>?,
          statusCode: statusCode,
        );
      }
    }

    // Handle different error types with comprehensive status codes
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
        message = localizations?.sendTimeout ?? 'الاتصال بطيء جداً! تحقق من سرعة الإنترنت وحاول مرة أخرى';
        break;
      case DioExceptionType.receiveTimeout:
        message = localizations?.receiveTimeout ?? 'الخادم يستغرق وقتاً أطول من المعتاد. حاول مرة أخرى';
        break;
      case DioExceptionType.badCertificate:
        message = localizations?.badCertificate ?? 'شهادة أمان غير صالحة';
        break;
      case DioExceptionType.badResponse:
        message = _getStatusCodeMessage(statusCode, localizations);
        break;
      case DioExceptionType.connectionError:
        message =
            localizations?.networkConnectionError ?? 'لا يوجد اتصال بالإنترنت';
        break;
      case DioExceptionType.cancel:
        message = localizations?.requestCancelled ?? 'تم إلغاء الطلب';
        break;
      case DioExceptionType.unknown:
        // Handle specific connection errors that fall under "unknown"
        final errorString = error.toString().toLowerCase();
        if (errorString.contains('connection closed') ||
            errorString.contains('connection reset') ||
            errorString.contains('connection refused') ||
            errorString.contains('httpexception')) {
          message =
              localizations?.connectionClosed ??
              'فشل الاتصال بالخادم. تأكد من اتصالك بالإنترنت وحاول مرة أخرى';
        } else if (errorString.contains('timeout') ||
            errorString.contains('timed out')) {
          message =
              localizations?.connectionTimeout ??
              'الاتصال بطيء جداً! تحقق من سرعة الإنترنت وحاول مرة أخرى';
        } else if (errorString.contains('socket') ||
            errorString.contains('network unreachable')) {
          message =
              localizations?.noInternetConnection ??
              'لا يوجد اتصال بالإنترنت. تحقق من اتصالك وحاول مرة أخرى';
        } else if (errorString.contains('host lookup failed') ||
            errorString.contains('dns')) {
          message =
              localizations?.serverNotResponding ??
              'الخادم لا يستجيب. حاول مرة أخرى لاحقاً';
        } else {
          message = localizations?.unknownNetworkError ?? 'خطأ شبكة غير معروف';
        }
        break;
    }

    return ApiException(
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  /// Get localized message for HTTP status codes
  String _getStatusCodeMessage(
    int? statusCode,
    AppLocalizations? localizations,
  ) {
    if (statusCode == null) {
      return localizations?.badResponse ?? 'استجابة غير صحيحة من الخادم';
    }

    switch (statusCode) {
      // 4xx Client Errors
      case 400:
        return localizations?.clientBadRequest ?? 'طلب غير صحيح';
      case 401:
        return localizations?.clientUnauthorized ?? 'غير مخول للوصول';
      case 403:
        return localizations?.clientForbidden ?? 'ممنوع الوصول لهذا المورد';
      case 404:
        return localizations?.clientNotFound ?? 'المورد المطلوب غير موجود';
      case 405:
        return localizations?.clientMethodNotAllowed ??
            'الطريقة المستخدمة غير مسموحة';
      case 406:
        return localizations?.clientNotAcceptable ?? 'المحتوى غير مقبول';
      case 408:
        return localizations?.clientRequestTimeout ?? 'انتهت مهلة الطلب';
      case 409:
        return localizations?.clientConflict ?? 'تعارض في البيانات';
      case 410:
        return localizations?.clientGone ?? 'المورد لم يعد متاحاً';
      case 411:
        return localizations?.clientLengthRequired ?? 'طول المحتوى مطلوب';
      case 412:
        return localizations?.clientPreconditionFailed ?? 'فشل في الشرط المسبق';
      case 413:
        return localizations?.clientPayloadTooLarge ?? 'حجم البيانات كبير جداً';
      case 414:
        return localizations?.clientUriTooLong ?? 'الرابط طويل جداً';
      case 415:
        return localizations?.clientUnsupportedMediaType ??
            'نوع الملف غير مدعوم';
      case 416:
        return localizations?.clientRangeNotSatisfiable ??
            'النطاق المطلوب غير متاح';
      case 417:
        return localizations?.clientExpectationFailed ?? 'فشل في التوقع';
      case 418:
        return localizations?.clientTeapot ?? 'أنا إبريق شاي (خطأ مرح)';
      case 422:
        return localizations?.clientUnprocessableEntity ??
            'البيانات غير قابلة للمعالجة';
      case 423:
        return localizations?.clientLocked ?? 'المورد مقفل';
      case 424:
        return localizations?.clientFailedDependency ?? 'فشل في التبعية';
      case 425:
        return localizations?.clientTooEarly ?? 'الطلب مبكر جداً';
      case 426:
        return localizations?.clientUpgradeRequired ??
            'ترقية البروتوكول مطلوبة';
      case 428:
        return localizations?.clientPreconditionRequired ?? 'شرط مسبق مطلوب';
      case 429:
        return localizations?.clientTooManyRequests ??
            'عدد كبير جداً من الطلبات - يرجى المحاولة لاحقاً';
      case 431:
        return localizations?.clientRequestHeaderFieldsTooLarge ??
            'حقول رأس الطلب كبيرة جداً';
      case 451:
        return localizations?.clientUnavailableForLegalReasons ??
            'غير متاح لأسباب قانونية';

      // 5xx Server Errors
      case 500:
        return localizations?.serverInternalError ?? 'خطأ داخلي في الخادم';
      case 501:
        return localizations?.serverNotImplemented ?? 'الميزة غير مطبقة';
      case 502:
        return localizations?.serverBadGateway ?? 'خطأ في بوابة الخادم';
      case 503:
        return localizations?.serverServiceUnavailable ??
            'الخدمة غير متاحة مؤقتاً';
      case 504:
        return localizations?.serverGatewayTimeout ??
            'انتهت مهلة الاستجابة من الخادم';
      case 505:
        return localizations?.serverHttpVersionNotSupported ??
            'إصدار HTTP غير مدعوم';
      case 506:
        return localizations?.serverVariantAlsoNegotiates ??
            'متغير يتفاوض أيضاً';
      case 507:
        return localizations?.serverInsufficientStorage ??
            'مساحة تخزين غير كافية';
      case 508:
        return localizations?.serverLoopDetected ?? 'تم اكتشاف حلقة مفرغة';
      case 510:
        return localizations?.serverNotExtended ?? 'غير ممدد';
      case 511:
        return localizations?.serverNetworkAuthenticationRequired ??
            'مصادقة الشبكة مطلوبة';

      default:
        if (statusCode >= 400 && statusCode < 500) {
          return localizations?.clientBadRequest ?? 'خطأ في الطلب';
        } else if (statusCode >= 500) {
          return localizations?.serverInternalError ?? 'خطأ في الخادم';
        } else {
          return localizations?.unexpectedError ?? 'حدث خطأ غير متوقع';
        }
    }
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
    if (_isRefreshing ||
        _tokenStorageService == null ||
        _authRepository == null) {
      return;
    }

    _isRefreshing = true;

    try {
      print('🔄 Proactively refreshing token...');

      final refreshData = await _authRepository!.refreshToken();
      final newToken = refreshData['access_token'] as String;
      final expiresIn = refreshData['expires_in'] as int?;

      // Update token in storage
      await _tokenStorageService!.updateAccessToken(
        newToken,
        expiresIn: expiresIn,
      );

      print('✅ Token refreshed proactively');
    } catch (e) {
      print('❌ Proactive token refresh failed: $e');
      // Don't clear tokens here, let the 401 handler deal with it
    } finally {
      _isRefreshing = false;
    }
  }
}
