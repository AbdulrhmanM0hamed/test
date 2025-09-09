import '../entities/home_product.dart';
import '../repositories/home_products_repository.dart';

class GetFeaturedProductsUseCase {
  final HomeProductsRepository repository;

  GetFeaturedProductsUseCase({required this.repository});

  Future<List<HomeProduct>> call() async {
    return await repository.getFeaturedProducts();
  }
}
