import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/core/models/api_response.dart';
import '../models/about_us_model.dart';

abstract class AboutUsRemoteDataSource {
  Future<ApiResponse<AboutUsModel>> getAboutUs();
}

class AboutUsRemoteDataSourceImpl implements AboutUsRemoteDataSource {
  final DioService dioService;

  AboutUsRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<AboutUsModel>> getAboutUs() async {
    return await dioService.getWithResponse<AboutUsModel>(
      ApiEndpoints.aboutUs,
      dataParser: (data) => AboutUsModel.fromJson(data),
    );
  }
}
