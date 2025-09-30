import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/data/datasources/sub_category_remote_data_source.dart';
import 'package:test/features/categories/domain/entities/sub_category.dart';
import 'package:test/features/categories/domain/repositories/sub_category_repository.dart';

class SubCategoryRepositoryImpl implements SubCategoryRepository {
  final SubCategoryRemoteDataSource remoteDataSource;

  SubCategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResponse<List<SubCategory>>> getSubCategories() async {
    try {
      final response = await remoteDataSource.getSubCategories();
      
      if (response.success) {
        final subCategories = response.data!
            .map((model) => model.toEntity())
            .toList();
        
        return ApiResponse.success(
          data: subCategories,
          message: response.message,
        );
      } else {
        return ApiResponse.error(message: response.message);
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'حدث خطأ أثناء جلب الفئات الفرعية: ${e.toString()}',
      );
    }
  }
}
