import '../../domain/entities/home_product.dart';
import '../../domain/entities/pagination_info.dart';
import 'home_product_model.dart';
import 'pagination_info_model.dart';

class HomeProductsResponseModel {
  final List<HomeProductModel> products;
  final PaginationInfoModel pagination;

  const HomeProductsResponseModel({required this.products, required this.pagination});

  factory HomeProductsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataSection = json['data'] as Map<String, dynamic>?;
    final items = (dataSection?['data'] as List?) ?? [];
    final products = items
        .map((e) => HomeProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final pagination = PaginationInfoModel.fromJson(dataSection ?? {});
    return HomeProductsResponseModel(products: products, pagination: pagination);
  }

  List<HomeProduct> toEntities() => products.map((e) => e.toEntity()).toList();
}
