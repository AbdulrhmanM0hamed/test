import '../../domain/entities/home_product.dart';
import '../../domain/repositories/home_products_repository.dart';
import '../datasources/home_products_remote_data_source.dart';

class HomeProductsRepositoryImpl implements HomeProductsRepository {
  final HomeProductsRemoteDataSource remoteDataSource;

  HomeProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomeProductsResponse> getFeaturedProducts({int page = 1}) async {
    final response = await remoteDataSource.getFeaturedProducts(page: page);
    return HomeProductsResponse(
      products: response.toEntities(),
      pagination: response.pagination,
    );
  }

  @override
  Future<HomeProductsResponse> getBestSellerProducts({int page = 1}) async {
    final response = await remoteDataSource.getBestSellerProducts(page: page);
    return HomeProductsResponse(
      products: response.toEntities(),
      pagination: response.pagination,
    );
  }

  @override
  Future<HomeProductsResponse> getLatestProducts({int page = 1}) async {
    final response = await remoteDataSource.getLatestProducts(page: page);
    return HomeProductsResponse(
      products: response.toEntities(),
      pagination: response.pagination,
    );
  }

  @override
  Future<HomeProductsResponse> getSpecialOfferProducts({int page = 1}) async {
    final response = await remoteDataSource.getSpecialOfferProducts(page: page);
    return HomeProductsResponse(
      products: response.toEntities(),
      pagination: response.pagination,
    );
  }
}
