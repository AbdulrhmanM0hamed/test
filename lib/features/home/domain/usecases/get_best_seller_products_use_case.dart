import '../repositories/home_products_repository.dart';

class GetBestSellerProductsUseCase {
  final HomeProductsRepository repository;

  GetBestSellerProductsUseCase({required this.repository});

  Future<HomeProductsResponse> call({int page = 1}) async {
    return await repository.getBestSellerProducts(page: page);
  }
}
