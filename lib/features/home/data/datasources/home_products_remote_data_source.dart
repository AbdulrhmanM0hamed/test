import '../../../../core/services/network/dio_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../core/services/location_service.dart';
import '../models/home_products_response_model.dart';
import '../models/pagination_info_model.dart';
import 'package:get_it/get_it.dart';

abstract class HomeProductsRemoteDataSource {
  Future<HomeProductsResponseModel> getFeaturedProducts({int page = 1});
  Future<HomeProductsResponseModel> getBestSellerProducts({int page = 1});
  Future<HomeProductsResponseModel> getLatestProducts({int page = 1});
  Future<HomeProductsResponseModel> getSpecialOfferProducts({int page = 1});
}

class HomeProductsRemoteDataSourceImpl implements HomeProductsRemoteDataSource {
  final DioService dioService;

  HomeProductsRemoteDataSourceImpl({required this.dioService});

  @override
  Future<HomeProductsResponseModel> getFeaturedProducts({int page = 1}) async {
    try {
      final locationService = GetIt.instance<LocationService>();
      final regionId = locationService.getSelectedRegionId();
      final response = await dioService.get(
        ApiEndpoints.featuredProductsUrl(regionId: regionId, page: page),
      );
      return HomeProductsResponseModel.fromJson(response.data);

    } catch (e) {
      return HomeProductsResponseModel(
        products: const [],
        pagination: const PaginationInfoModel(perPage: 0, to: 0, total: 0),
      );
    }
  }

  @override
  Future<HomeProductsResponseModel> getBestSellerProducts({int page = 1}) async {
    try {
      final locationService = GetIt.instance<LocationService>();
      final regionId = locationService.getSelectedRegionId();
      final response = await dioService.get(
        ApiEndpoints.bestSellerProductsUrl(regionId: regionId, page: page),
      );
      return HomeProductsResponseModel.fromJson(response.data);
    } catch (e) {
      return HomeProductsResponseModel(
        products: const [],
        pagination: const PaginationInfoModel(perPage: 0, to: 0, total: 0),
      );
    }
  }

  @override
  Future<HomeProductsResponseModel> getLatestProducts({int page = 1}) async {
    try {
      final locationService = GetIt.instance<LocationService>();
      final regionId = locationService.getSelectedRegionId();
      final response = await dioService.get(
        ApiEndpoints.latestProductsUrl(regionId: regionId, page: page),
      );
      return HomeProductsResponseModel.fromJson(response.data);
    } catch (e) {
      return HomeProductsResponseModel(
        products: const [],
        pagination: const PaginationInfoModel(perPage: 0, to: 0, total: 0),
      );
    }
  }

  @override
  Future<HomeProductsResponseModel> getSpecialOfferProducts({int page = 1}) async {
    try {
      final locationService = GetIt.instance<LocationService>();
      final regionId = locationService.getSelectedRegionId();
      final response = await dioService.get(
        ApiEndpoints.specialOfferProductsUrl(regionId: regionId, page: page),
      );
      return HomeProductsResponseModel.fromJson(response.data);
    } catch (e) {
      return HomeProductsResponseModel(
        products: const [],
        pagination: const PaginationInfoModel(perPage: 0, to: 0, total: 0),
      );
    }
  }
}
