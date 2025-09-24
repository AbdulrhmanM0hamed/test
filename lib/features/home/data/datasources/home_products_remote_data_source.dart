import '../../../../core/services/network/dio_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../core/services/location_service.dart';
import '../models/home_product_model.dart';
import 'package:get_it/get_it.dart';

abstract class HomeProductsRemoteDataSource {
  Future<List<HomeProductModel>> getFeaturedProducts();
  Future<List<HomeProductModel>> getBestSellerProducts();
  Future<List<HomeProductModel>> getLatestProducts();
  Future<List<HomeProductModel>> getSpecialOfferProducts();
}

class HomeProductsRemoteDataSourceImpl implements HomeProductsRemoteDataSource {
  final DioService dioService;

  HomeProductsRemoteDataSourceImpl({required this.dioService});

  @override
  Future<List<HomeProductModel>> getFeaturedProducts() async {
    try {
      final locationService = GetIt.instance<LocationService>();
      final regionId = locationService.getSelectedRegionId();
      final response = await dioService.get(
        ApiEndpoints.featuredProductsUrl(regionId: regionId),
      );
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final Map<String, dynamic>? dataSection =
          responseData['data'] as Map<String, dynamic>?;

      if (dataSection == null) return [];

      final List<dynamic> productsJson =
          dataSection['data'] as List<dynamic>? ?? [];
      return productsJson
          .map(
            (json) => HomeProductModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      //print('Error in getFeaturedProducts: $e');
      return [];
    }
  }

  @override
  Future<List<HomeProductModel>> getBestSellerProducts() async {
    try {
      final locationService = GetIt.instance<LocationService>();
      final regionId = locationService.getSelectedRegionId();
      final response = await dioService.get(
        ApiEndpoints.bestSellerProductsUrl(regionId: regionId),
      );
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final Map<String, dynamic>? dataSection =
          responseData['data'] as Map<String, dynamic>?;

      if (dataSection == null) return [];

      final List<dynamic> productsJson =
          dataSection['data'] as List<dynamic>? ?? [];
      return productsJson
          .map(
            (json) => HomeProductModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      //print('Error in getBestSellerProducts: $e');
      return [];
    }
  }

  @override
  Future<List<HomeProductModel>> getLatestProducts() async {
    try {
      final locationService = GetIt.instance<LocationService>();
      final regionId = locationService.getSelectedRegionId();
      final response = await dioService.get(
        ApiEndpoints.latestProductsUrl(regionId: regionId),
      );
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final Map<String, dynamic>? dataSection =
          responseData['data'] as Map<String, dynamic>?;

      if (dataSection == null) return [];

      final List<dynamic> productsJson =
          dataSection['data'] as List<dynamic>? ?? [];
      return productsJson
          .map(
            (json) => HomeProductModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      //print('Error in getLatestProducts: $e');
      return [];
    }
  }

  @override
  Future<List<HomeProductModel>> getSpecialOfferProducts() async {
    try {
      final locationService = GetIt.instance<LocationService>();
      final regionId = locationService.getSelectedRegionId();
      final response = await dioService.get(
        ApiEndpoints.specialOfferProductsUrl(regionId: regionId),
      );

      //print('Special Offer Response type: ${response.runtimeType}');

      // Extract data from Response object
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      //print('Special Offer Response data: ${responseData.toString().substring(0, 200)}...');

      final Map<String, dynamic>? dataSection =
          responseData['data'] as Map<String, dynamic>?;

      if (dataSection == null) {
        //print('Data section is null');
        return [];
      }

      final List<dynamic> productsJson =
          dataSection['data'] as List<dynamic>? ?? [];
      //print('Special Offer Products JSON count: ${productsJson.length}');

      final products = productsJson
          .map(
            (json) => HomeProductModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      //print('Special Offer Products parsed count: ${products.length}');
      return products;
    } catch (e) {
      //print('Error in getSpecialOfferProducts: $e');
      return [];
    }
  }
}
