import 'package:dio/dio.dart';

class ErrorHandler {
  static String extractErrorMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else if (error is Exception) {
      return _handleGeneralException(error);
    } else {
      return _getDefaultErrorMessage();
    }
  }

  static String _handleDioException(DioException dioError) {
    // First try to extract server message from response
    if (dioError.response?.data != null) {
      final responseData = dioError.response!.data;
      
      if (responseData is Map<String, dynamic>) {
        final serverMessage = responseData['message'];
        if (serverMessage != null && serverMessage.toString().isNotEmpty) {
          return serverMessage.toString();
        }
      }
    }

    // Fallback to status code based messages
    switch (dioError.response?.statusCode) {
      case 400:
        return 'بيانات غير صحيحة';
      case 401:
        return 'بيانات الدخول غير صحيحة';
      case 403:
        return 'غير مصرح لك بالوصول';
      case 404:
        return 'الخدمة غير متوفرة';
      case 422:
        return 'بيانات غير مكتملة أو غير صحيحة';
      case 500:
        return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
      default:
        return _getNetworkErrorMessage(dioError.type);
    }
  }

  static String _handleGeneralException(Exception exception) {
    final message = exception.toString();
    
    // Remove "Exception: " prefix if exists
    if (message.startsWith('Exception: ')) {
      return message.substring(11);
    }
    
    return message;
  }

  static String _getNetworkErrorMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
      case DioExceptionType.badCertificate:
        return 'مشكلة في الأمان، يرجى المحاولة لاحقاً';
      case DioExceptionType.cancel:
        return 'تم إلغاء العملية';
      default:
        return _getDefaultErrorMessage();
    }
  }

  static String _getDefaultErrorMessage() {
    return 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى';
  }
}
