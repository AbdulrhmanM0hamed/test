/// Base API response model for handling server responses
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.success({
    required String message,
    T? data,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    required String message,
    Map<String, dynamic>? errors,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  /// Create ApiResponse from server JSON response
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? dataParser,
  }) {
    final bool isSuccess = json['status'] == 200 || json['status'] == 201;
    final String message = json['message'] ?? 'Unknown response';
    final int? statusCode = json['status'];

    if (isSuccess) {
      T? parsedData;
      if (json['data'] != null && dataParser != null) {
        parsedData = dataParser(json['data']);
      }
      
      return ApiResponse.success(
        message: message,
        data: parsedData,
        statusCode: statusCode,
      );
    } else {
      return ApiResponse.error(
        message: message,
        errors: json['errors'] as Map<String, dynamic>?,
        statusCode: statusCode,
      );
    }
  }

  /// Get the first error message from errors map
  String? getFirstErrorMessage() {
    if (errors == null || errors!.isEmpty) return null;
    
    for (final fieldErrors in errors!.values) {
      if (fieldErrors is List && fieldErrors.isNotEmpty) {
        return fieldErrors.first.toString();
      }
    }
    return null;
  }

  /// Get error message for a specific field
  String? getFieldError(String fieldName) {
    if (errors == null || !errors!.containsKey(fieldName)) return null;
    
    final fieldErrors = errors![fieldName];
    if (fieldErrors is List && fieldErrors.isNotEmpty) {
      return fieldErrors.first.toString();
    }
    return null;
  }

  /// Get all error messages as a single string
  String getAllErrorMessages() {
    if (errors == null || errors!.isEmpty) return message;
    
    final List<String> allErrors = [];
    for (final fieldErrors in errors!.values) {
      if (fieldErrors is List) {
        allErrors.addAll(fieldErrors.map((e) => e.toString()));
      }
    }
    
    return allErrors.isNotEmpty ? allErrors.join('\n') : message;
  }
}

/// Exception class for API errors with structured error handling
class ApiException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  const ApiException({
    required this.message,
    this.errors,
    this.statusCode,
  });

  factory ApiException.fromResponse(Map<String, dynamic> responseData, int? statusCode) {
    return ApiException(
      message: responseData['message'] ?? 'Unknown error occurred',
      errors: responseData['errors'] as Map<String, dynamic>?,
      statusCode: statusCode,
    );
  }

  /// Get the first error message
  String getFirstErrorMessage() {
    if (errors == null || errors!.isEmpty) return message;
    
    for (final fieldErrors in errors!.values) {
      if (fieldErrors is List && fieldErrors.isNotEmpty) {
        return fieldErrors.first.toString();
      }
    }
    return message;
  }

  @override
  String toString() => message;
}
