import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/data/models/sub_category_model.dart';

abstract class SubCategoryRemoteDataSource {
  Future<ApiResponse<List<SubCategoryModel>>> getSubCategories();
}

class SubCategoryRemoteDataSourceImpl implements SubCategoryRemoteDataSource {
  final DioService dioService;

  SubCategoryRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<List<SubCategoryModel>>> getSubCategories() async {
    try {
      final response = await dioService.get(ApiEndpoints.subCategories);
      
      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        final subCategories = data
            .map((json) => SubCategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        return ApiResponse.success(
          data: subCategories,
          message: response.data['message'] as String? ?? 'تم جلب الفئات الفرعية بنجاح',
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] as String? ?? 'فشل في جلب الفئات الفرعية',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'حدث خطأ أثناء جلب الفئات الفرعية: ${e.toString()}',
      );
    }
  }
}
