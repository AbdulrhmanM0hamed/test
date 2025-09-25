import '../repositories/home_products_repository.dart';

class GetSpecialOfferProductsUseCase {
  final HomeProductsRepository repository;

  GetSpecialOfferProductsUseCase({required this.repository});

  Future<HomeProductsResponse> call({int page = 1}) async {
    return await repository.getSpecialOfferProducts(page: page);
  }
}
