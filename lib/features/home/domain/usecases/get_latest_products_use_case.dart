import '../entities/home_product.dart';
import '../repositories/home_products_repository.dart';

class GetLatestProductsUseCase {
  final HomeProductsRepository repository;

  GetLatestProductsUseCase({required this.repository});

  Future<List<HomeProduct>> call() async {
    return await repository.getLatestProducts();
  }
}
