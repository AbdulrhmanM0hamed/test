import 'package:test/core/models/api_response.dart';
import 'package:test/features/categories/data/models/product_filter_model.dart';
import 'package:test/features/categories/data/models/product_model.dart';
import 'package:test/features/categories/domain/entities/product_filter.dart';
import 'package:test/features/categories/domain/repositories/products_repository.dart';

class GetAllProductsUseCase {
  final ProductsRepository repository;

  const GetAllProductsUseCase({required this.repository});

  Future<ApiResponse<ProductsResponseModel>> call(ProductFilter filter) async {
    final filterModel = ProductFilterModel(
      mainCategoryId: filter.mainCategoryId,
      subCategoryId: filter.subCategoryId,
      minPrice: filter.minPrice,
      maxPrice: filter.maxPrice,
      rate: filter.rate,
      departmentId: filter.departmentId,
      brandId: filter.brandId,
      platform: filter.platform,
      colorId: filter.colorId,
      sizeId: filter.sizeId,
      keyword: filter.keyword,
      countryId: filter.countryId,
      tags: filter.tags,
      page: filter.page,
    );

    return await repository.getAllProducts(filterModel);
  }
}
