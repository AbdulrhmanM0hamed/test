import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/domain/entities/sub_category.dart';
import 'package:test/features/categories/domain/repositories/sub_category_repository.dart';

class GetSubCategoriesUseCase {
  final SubCategoryRepository repository;

  GetSubCategoriesUseCase({required this.repository});

  Future<ApiResponse<List<SubCategory>>> call() async {
    return await repository.getSubCategories();
  }
}
