import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/models/api_response.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/home/data/datasources/sub_categories_remote_data_source.dart';
import 'package:test/features/home/data/models/sub_category_model.dart';

class SubCategoriesRemoteDataSourceImpl implements SubCategoriesRemoteDataSource {
  final DioService dioService;

  SubCategoriesRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<List<SubCategoryModel>>> getSubCategories() async {
    try {
      final response = await dioService.getWithResponse(
        '${ApiEndpoints.subCategories}?limit=3',
        dataParser: (data) {
          if (data is List) {
            return data.map((item) => SubCategoryModel.fromJson(item)).toList();
          }
          return <SubCategoryModel>[];
        },
      );
      
      return response;
    } catch (e) {
      throw Exception('Failed to fetch sub-categories: $e');
    }
  }
}
