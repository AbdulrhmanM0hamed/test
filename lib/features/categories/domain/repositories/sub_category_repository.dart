import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/domain/entities/sub_category.dart';

abstract class SubCategoryRepository {
  Future<ApiResponse<List<SubCategory>>> getSubCategories();
}
