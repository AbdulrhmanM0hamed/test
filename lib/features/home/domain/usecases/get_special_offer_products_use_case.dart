import '../entities/home_product.dart';
import '../repositories/home_products_repository.dart';

class GetSpecialOfferProductsUseCase {
  final HomeProductsRepository repository;

  GetSpecialOfferProductsUseCase({required this.repository});

  Future<List<HomeProduct>> call() async {
    return await repository.getSpecialOfferProducts();
  }
}
