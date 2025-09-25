import '../repositories/home_products_repository.dart';

class GetLatestProductsUseCase {
  final HomeProductsRepository repository;

  GetLatestProductsUseCase({required this.repository});

  Future<HomeProductsResponse> call({int page = 1}) async {
    return await repository.getLatestProducts(page: page);
  }
}
