import '../repositories/home_products_repository.dart';

class GetFeaturedProductsUseCase {
  final HomeProductsRepository repository;

  GetFeaturedProductsUseCase({required this.repository});

  Future<HomeProductsResponse> call({int page = 1}) async {
    return await repository.getFeaturedProducts(page: page);
  }
}
