import 'package:test/features/categories/domain/entities/product.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final ProductsPagination pagination;
  final String departmentName;

  ProductsLoaded({
    required this.products,
    required this.pagination,
    required this.departmentName,
  });
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}
