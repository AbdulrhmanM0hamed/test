import 'package:test/core/models/api_response.dart';
import 'package:test/features/home/data/models/sub_category_model.dart';

abstract class SubCategoriesRemoteDataSource {
  Future<ApiResponse<List<SubCategoryModel>>> getSubCategories();
}
