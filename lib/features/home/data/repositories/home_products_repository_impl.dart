import '../../domain/entities/home_product.dart';
import '../../domain/repositories/home_products_repository.dart';
import '../datasources/home_products_remote_data_source.dart';

class HomeProductsRepositoryImpl implements HomeProductsRepository {
  final HomeProductsRemoteDataSource remoteDataSource;

  HomeProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HomeProduct>> getFeaturedProducts() async {
    final productModels = await remoteDataSource.getFeaturedProducts();
    return productModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<HomeProduct>> getBestSellerProducts() async {
    final productModels = await remoteDataSource.getBestSellerProducts();
    return productModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<HomeProduct>> getLatestProducts() async {
    final productModels = await remoteDataSource.getLatestProducts();
    return productModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<HomeProduct>> getSpecialOfferProducts() async {
    final productModels = await remoteDataSource.getSpecialOfferProducts();
    return productModels.map((model) => model.toEntity()).toList();
  }
}
