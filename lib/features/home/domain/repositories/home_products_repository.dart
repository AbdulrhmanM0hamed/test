import '../entities/home_product.dart';
import '../entities/pagination_info.dart';

class HomeProductsResponse {
  final List<HomeProduct> products;
  final PaginationInfo pagination;

  const HomeProductsResponse({required this.products, required this.pagination});
}

abstract class HomeProductsRepository {
  Future<HomeProductsResponse> getFeaturedProducts({int page = 1});
  Future<HomeProductsResponse> getBestSellerProducts({int page = 1});
  Future<HomeProductsResponse> getLatestProducts({int page = 1});
  Future<HomeProductsResponse> getSpecialOfferProducts({int page = 1});
}
