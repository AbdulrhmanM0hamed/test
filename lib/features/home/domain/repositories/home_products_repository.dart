import '../entities/home_product.dart';

abstract class HomeProductsRepository {
  Future<List<HomeProduct>> getFeaturedProducts();
  Future<List<HomeProduct>> getBestSellerProducts();
  Future<List<HomeProduct>> getLatestProducts();
  Future<List<HomeProduct>> getSpecialOfferProducts();
}
