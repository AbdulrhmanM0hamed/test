import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/network_info.dart';
import '../datasources/contact_us_remote_data_source.dart';
import '../models/contact_info_model.dart';
import '../../domain/repositories/contact_us_repository.dart';

class ContactUsRepositoryImpl implements ContactUsRepository {
  final ContactUsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ContactUsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<ApiResponse<ContactInfoModel>> getContactInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getContactInfo();
        if (response.success) {
          return ApiResponse.success(
            data: response.data!,
            message: response.message,
          );
        } else {
          return ApiResponse.error(message: response.message);
        }
      } catch (e) {
        return ApiResponse.error(message: 'Network error occurred');
      }
    } else {
      return ApiResponse.error(message: 'No internet connection');
    }
  }
}
