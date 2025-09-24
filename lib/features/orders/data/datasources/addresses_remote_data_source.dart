import 'package:dio/dio.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/services/network/dio_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/address_model.dart';

abstract class AddressesRemoteDataSource {
  Future<ApiResponse<List<AddressModel>>> getAddresses();
  Future<ApiResponse<AddressModel>> addAddress(AddressModel address);
  Future<ApiResponse<AddressModel>> updateAddress(
    int addressId,
    AddressModel address,
  );
  Future<ApiResponse<void>> deleteAddress(int addressId);
}

class AddressesRemoteDataSourceImpl implements AddressesRemoteDataSource {
  final DioService dioService;

  AddressesRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<List<AddressModel>>> getAddresses() async {
    try {
      final response = await dioService.getWithResponse(
        ApiEndpoints.addresses,
        dataParser: (data) {
          if (data is List) {
            return data
                .map((address) => AddressModel.fromJson(address))
                .toList();
          }
          return <AddressModel>[];
        },
      );
      return response;
    } on ApiException catch (e) {
      // DioService already extracted the server message
      return ApiResponse.error(message: e.message);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.response?.statusCode == 500 ||
          e.response?.statusCode == 422) {
        // Extract server error message
        final serverMessage =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error occurred';
        return ApiResponse.error(message: serverMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        // Try to extract server message for other errors
        final serverMessage =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error occurred';
        return ApiResponse.error(message: serverMessage);
      }
    } catch (e) {
      return ApiResponse.error(message: 'Unknown error occurred');
    }
  }

  @override
  Future<ApiResponse<AddressModel>> addAddress(AddressModel address) async {
    try {
      final response = await dioService.postWithResponse(
        ApiEndpoints.addresses,
        data: address.toCreateJson(),
        dataParser: (data) => AddressModel.fromJson(data),
      );
      return response;
    } on ApiException catch (e) {
      // DioService already extracted the server message
      return ApiResponse.error(message: e.message);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.response?.statusCode == 500 ||
          e.response?.statusCode == 422) {
        // Extract server error message
        final serverMessage =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error occurred';
        return ApiResponse.error(message: serverMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        // Try to extract server message for other errors
        final serverMessage =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error occurred';
        return ApiResponse.error(message: serverMessage);
      }
    } catch (e) {
      return ApiResponse.error(message: 'Unknown error occurred');
    }
  }

  @override
  Future<ApiResponse<AddressModel>> updateAddress(
    int addressId,
    AddressModel address,
  ) async {
    try {
      final response = await dioService.putWithResponse(
        '${ApiEndpoints.addresses}/$addressId',
        data: address.toUpdateJson(),
        dataParser: (data) {
          // Handle case where server returns empty array on success
          if (data is List && data.isEmpty) {
            // Return the original address with updated data since server doesn't return the updated object
            return address;
          }
          return AddressModel.fromJson(data);
        },
      );
      return response;
    } on ApiException catch (e) {
      // DioService already extracted the server message
      return ApiResponse.error(message: e.message);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.response?.statusCode == 500 ||
          e.response?.statusCode == 422) {
        // Extract server error message
        final serverMessage =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error occurred';
        return ApiResponse.error(message: serverMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        // Try to extract server message for other errors
        final serverMessage =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error occurred';
        return ApiResponse.error(message: serverMessage);
      }
    } catch (e) {
      return ApiResponse.error(message: 'Unknown error occurred');
    }
  }

  @override
  Future<ApiResponse<void>> deleteAddress(int addressId) async {
    try {
      final response = await dioService.deleteWithResponse(
        '${ApiEndpoints.addresses}/$addressId',
      );
      return response;
    } on ApiException catch (e) {
      // DioService already extracted the server message
      return ApiResponse.error(message: e.message);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse.error(message: 'Authentication required');
      } else if (e.response?.statusCode == 500 ||
          e.response?.statusCode == 422) {
        // Extract server error message
        final serverMessage =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error occurred';
        return ApiResponse.error(message: serverMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.error(message: 'Network timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error(message: 'Network connection error');
      } else {
        // Try to extract server message for other errors
        final serverMessage =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Server error occurred';
        return ApiResponse.error(message: serverMessage);
      }
    } catch (e) {
      return ApiResponse.error(message: 'Unknown error occurred');
    }
  }
}
