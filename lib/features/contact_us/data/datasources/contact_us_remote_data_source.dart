import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/core/models/api_response.dart';
import '../models/contact_info_model.dart';

abstract class ContactUsRemoteDataSource {
  Future<ApiResponse<ContactInfoModel>> getContactInfo();
}

class ContactUsRemoteDataSourceImpl implements ContactUsRemoteDataSource {
  final DioService dioService;

  ContactUsRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<ContactInfoModel>> getContactInfo() async {
    return await dioService.getWithResponse<ContactInfoModel>(
      ApiEndpoints.contactUs,
      dataParser: (data) => ContactInfoModel.fromJson(data),
    );
  }
}
