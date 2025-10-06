import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/core/models/api_response.dart';
import '../models/faq_model.dart';

abstract class FAQRemoteDataSource {
  Future<ApiResponse<List<FAQModel>>> getFAQs();
}

class FAQRemoteDataSourceImpl implements FAQRemoteDataSource {
  final DioService dioService;

  FAQRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<List<FAQModel>>> getFAQs() async {
    return await dioService.getWithResponse<List<FAQModel>>(
      ApiEndpoints.faq,
      dataParser: (data) {
        final List<dynamic> faqList = data as List<dynamic>;
        return faqList.map((faq) => FAQModel.fromJson(faq)).toList();
      },
    );
  }
}
