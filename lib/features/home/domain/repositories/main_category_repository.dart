import 'package:test/core/models/api_response.dart';
import 'package:test/features/home/domain/entities/main_category.dart';

abstract class MainCategoryRepository {
  Future<ApiResponse<List<MainCategory>>> getMainCategories();
}
