import 'package:test/features/categories/domain/entities/product.dart';
import 'package:test/features/categories/domain/entities/product_filter.dart';

/// حالة فلترة المنتجات
class ProductsFilterState {
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? error;
  final int currentPage;
  final ProductFilter filter;
  final List<dynamic> availableCategories;
  final List<dynamic> availableSubCategories;

  const ProductsFilterState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.error,
    this.currentPage = 1,
    this.filter = const ProductFilter(),
    this.availableCategories = const [],
    this.availableSubCategories = const [],
  });

  ProductsFilterState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? error,
    int? currentPage,
    ProductFilter? filter,
    List<dynamic>? availableCategories,
    List<dynamic>? availableSubCategories,
  }) {
    return ProductsFilterState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      filter: filter ?? this.filter,
      availableCategories: availableCategories ?? this.availableCategories,
      availableSubCategories: availableSubCategories ?? this.availableSubCategories,
    );
  }

  @override
  String toString() {
    return 'ProductsFilterState(products: ${products.length}, isLoading: $isLoading, filter: $filter)';
  }
}
