import 'package:test/core/models/api_response.dart';
import 'package:test/features/home/domain/entities/main_category.dart';
import 'package:test/features/home/domain/repositories/main_category_repository.dart';

class GetMainCategoriesUseCase {
  final MainCategoryRepository repository;

  GetMainCategoriesUseCase({required this.repository});

  Future<ApiResponse<List<MainCategory>>> call() async {
    return await repository.getMainCategories();
  }
}
