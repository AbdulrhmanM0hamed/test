import '../entities/home_product.dart';
import '../repositories/home_products_repository.dart';

class GetBestSellerProductsUseCase {
  final HomeProductsRepository repository;

  GetBestSellerProductsUseCase({required this.repository});

  Future<List<HomeProduct>> call() async {
    return await repository.getBestSellerProducts();
  }
}
