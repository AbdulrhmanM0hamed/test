import 'package:test/core/models/api_response.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/utils/constant/api_endpoints.dart';
import 'package:test/features/categories/data/models/product_model.dart';
import 'package:test/features/categories/data/models/product_filter_model.dart';

abstract class ProductsRemoteDataSource {
  Future<ApiResponse<ProductsResponseModel>> getProductsByDepartment(
    String departmentName, {
    int page = 1,
  });

  Future<ApiResponse<ProductsResponseModel>> getAllProducts(
    ProductFilterModel filter,
  );
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final DioService dioService;

  const ProductsRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ApiResponse<ProductsResponseModel>> getProductsByDepartment(
    String departmentName, {
    int page = 1,
  }) async {
    try {
      final response = await dioService.get(
        ApiEndpoints.productsByDepartment(departmentName),
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final productsResponse = ProductsResponseModel.fromJson(response.data);
        return ApiResponse.success(
          data: productsResponse,
          message: response.data['message'] ?? 'تم تحميل المنتجات بنجاح',
        );
      } else {
        return ApiResponse.error(
          message:
              response.data['message'] ??
              'فشل في تحميل المنتجات، يرجى المحاولة مرة أخرى',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'تعذر الاتصال بالخادم، تأكد من اتصالك بالإنترنت',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ApiResponse<ProductsResponseModel>> getAllProducts(
    ProductFilterModel filter,
  ) async {
    try {
      final url = ApiEndpoints.getAllProducts(
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
        regionId: filter.regionId,
        tags: filter.tags,
        page: filter.page,
      );

      ////print('🌐 API URL: $url');
      ////print('🔍 Filter Parameters: ${filter.toJson()}');

      final response = await dioService.get(url);

      ////print('📡 API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final productsResponse = ProductsResponseModel.fromJson(response.data);
        ////print('✅ Successfully loaded ${productsResponse.data.length} products');

        return ApiResponse.success(
          data: productsResponse,
          message: response.data['message'] ?? 'تم تحميل المنتجات بنجاح',
        );
      } else {
        return ApiResponse.error(
          message:
              response.data['message'] ??
              'فشل في تحميل المنتجات، يرجى المحاولة مرة أخرى',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      ////print('🚨 Network Error: $e');
      return ApiResponse.error(
        message: 'تعذر الاتصال بالخادم، تأكد من اتصالك بالإنترنت',
        statusCode: 500,
      );
    }
  }
}
